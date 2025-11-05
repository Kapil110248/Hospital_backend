import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();
import { v4 as uuidv4 } from 'uuid';




export const createAppointment = async (req, res) => {
  try {
    const {
      patientId,
      doctorId,
      department, // enum string from frontend
      scheduledAt,
      durationMins,
      status,
      reason,
      notes,
      createdById
    } = req.body;

    if (!patientId || !scheduledAt || !department) {
      return res.status(400).json({ message: "patientId, department & scheduledAt required" });
    }

    // ✅ Validate scheduledAt
    const scheduledDate = new Date(scheduledAt);
    if (isNaN(scheduledDate.getTime())) {
      return res.status(400).json({ message: "Invalid scheduledAt datetime" });
    }

    // ✅ Map or create Department record automatically
    let departmentRecord = await prisma.department.findFirst({
      where: { type: department }
    });

    if (!departmentRecord) {
      departmentRecord = await prisma.department.create({
        data: { name: `${department} Department`, type: department }
      });
    }

    const departmentId = departmentRecord.id;

    // ✅ Generate unique appointmentNumber using UUID
    const appointmentNumber = `APT-${uuidv4()}`;

    const appointment = await prisma.appointment.create({
      data: {
        patientId,
        doctorId,
        departmentId,
        scheduledAt: scheduledDate,
        durationMins: durationMins || 30,
        status: status || "SCHEDULED",
        reason,
        notes,
        createdById,
        appointmentNumber
      },
      include: {
        patient: true,
        doctor: true,
        department: true
      }
    });

    res.status(201).json({ message: "Appointment created", appointment });
  } catch (error) {
    console.error("Error creating appointment:", error);
    res.status(500).json({ message: "Server error", error });
  }
};



/**
 * ✅ Get All Appointments
 */
export const getAllAppointments = async (req, res) => {
  try {
    const appointments = await prisma.appointment.findMany({
      where: { isDeleted: false },
      orderBy: { id: "desc" },
      include: {
        patient: true,
        doctor: true,
        department: true
      }
    });

    res.status(200).json(appointments);
  } catch (error) {
    console.error("Error fetching appointments:", error);
    res.status(500).json({ message: "Server error", error });
  }
};


/**
 * ✅ Get Appointment by ID
 */
export const getAppointmentById = async (req, res) => {
  try {
    const { id } = req.params;

    const appointment = await prisma.appointment.findUnique({
      where: { id: parseInt(id) },
      include: {
        patient: true,
        doctor: true,
        department: true,
        prescriptions: true,
        labRequests: true,
        radiologyRequests: true
      }
    });

    if (!appointment)
      return res.status(404).json({ message: "Appointment not found" });

    res.status(200).json(appointment);
  } catch (error) {
    console.error("Error fetching appointment:", error);
    res.status(500).json({ message: "Server error", error });
  }
};


/**
 * ✅ Update Appointment
 */
export const updateAppointment = async (req, res) => {
  try {
    const { id } = req.params;
    const { department, scheduledAt, ...rest } = req.body;

    const existing = await prisma.appointment.findUnique({
      where: { id: parseInt(id) }
    });

    if (!existing) {
      return res.status(404).json({ message: "Appointment not found" });
    }

    let updateData = { ...rest };

    if (department) {
      // ✅ Map or create Department record automatically
      let departmentRecord = await prisma.department.findFirst({
        where: { type: department }
      });

      if (!departmentRecord) {
        departmentRecord = await prisma.department.create({
          data: { name: `${department} Department`, type: department }
        });
      }

      updateData.departmentId = departmentRecord.id;
    }

    if (scheduledAt) {
      const scheduledDate = new Date(scheduledAt);
      if (isNaN(scheduledDate.getTime())) {
        return res.status(400).json({ message: "Invalid scheduledAt datetime" });
      }
      updateData.scheduledAt = scheduledDate;
    }

    const updated = await prisma.appointment.update({
      where: { id: parseInt(id) },
      data: updateData,
      include: {
        patient: true,
        doctor: true,
        department: true
      }
    });

    res.status(200).json({ message: "Appointment updated", updated });
  } catch (error) {
    console.error("Error updating appointment:", error);
    res.status(500).json({ message: "Server error", error });
  }
};




/**
 * ✅ Soft Delete Appointment
 */
export const deleteAppointment = async (req, res) => {
  try {
    const { id } = req.params;

    const existing = await prisma.appointment.findUnique({
      where: { id: parseInt(id) }
    });

    if (!existing)
      return res.status(404).json({ message: "Appointment not found" });

    const deleted = await prisma.appointment.update({
      where: { id: parseInt(id) },
      data: {
        isDeleted: true,
        isActive: false,
        deletedAt: new Date()
      }
    });

    res.status(200).json({ message: "Appointment Deleted", deleted });
  } catch (error) {
    console.error("Error deleting appointment:", error);
    res.status(500).json({ message: "Server error", error });
  }
};
