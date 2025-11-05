import { PrismaClient } from "@prisma/client";
import { v4 as uuidv4 } from "uuid"; // uuid generate karne ke liye
const prisma = new PrismaClient();

export const createPrescription = async (req, res) => {
  try {
    const { prescriptionNumber, patientId, doctorId, notes, items } = req.body;

    if (!patientId || !doctorId || !items || items.length === 0) {
      return res.status(400).json({ message: "patientId, doctorId & items are required" });
    }

    // ✅ Generate publicId automatically
    const publicId = uuidv4();

    const prescription = await prisma.prescription.create({
      data: {
        publicId,
        prescriptionNumber,
        patientId,
        doctorId,
        notes,
        items: {
          create: items.map((item) => ({
            medicineId: item.medicineId,
            dosage: item.dosage,
            quantity: item.quantity,
            durationDays: item.durationDays,
            instructions: item.instructions,
          })),
        },
      },
      include: {
        items: true,
        patient: true,
        doctor: true,
      },
    });

    res.status(201).json({ message: "Prescription created", prescription });
  } catch (error) {
    console.error("Error creating prescription:", error);
    res.status(500).json({ message: "Server error", error });
  }
};

/**
 * ✅ Get all prescriptions
 */
export const getAllPrescriptions = async (req, res) => {
  try {
    const prescriptions = await prisma.prescription.findMany({
      include: {
        patient: { include: { user: true } },
        doctor: { include: { user: true } },

        // ❌ earlier: prescriptionitem
        // ✅ fixed: items
        items: {
          include: {
            medicine: true,
          },
        },
      },
      orderBy: { createdAt: "desc" },
    });

    res.status(200).json({
      success: true,
      data: prescriptions,
    });
  } catch (error) {
    console.error("Error fetching prescriptions:", error);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

/**
 * ✅ Get prescription by ID
 */
export const getPrescriptionById = async (req, res) => {
  try {
    const { id } = req.params;

    const prescription = await prisma.prescription.findUnique({
      where: { id: Number(id) },
      include: {
        patient: { include: { user: true } },
        doctor: { include: { user: true } },

        // ✅ fix here too
        items: { include: { medicine: true } },
      },
    });

    if (!prescription) {
      return res.status(404).json({ success: false, message: "Not found" });
    }

    res.status(200).json({ success: true, data: prescription });
  } catch (error) {
    console.error("Error fetching prescription:", error);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

/**
 * ✅ Delete prescription
 */
export const deletePrescription = async (req, res) => {
  try {
    const { id } = req.params;

    // ❌ wrong: prescriptionitem
    // ✅ correct: prescriptionItem (model name in prisma)
    await prisma.prescriptionItem.deleteMany({
      where: { prescriptionId: Number(id) },
    });

    await prisma.prescription.delete({
      where: { id: Number(id) },
    });

    res.status(200).json({
      success: true,
      message: "Prescription deleted successfully.",
    });
  } catch (error) {
    console.error("Error deleting prescription:", error);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};
