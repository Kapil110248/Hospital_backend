import express from "express";
import { PrismaClient } from "@prisma/client";
import cors from "cors";

const app = express();
const prisma = new PrismaClient();

app.use(cors());
app.use(express.json());

// 🔹 MCP manifest (registry endpoints)
app.get("/mcp/manifest", (req, res) => {
  res.json({
    name: "hospital-prisma",
    version: "1.0.0",
    tools: [
      {
        name: "list_patients",
        description: "Get all patients",
        method: "GET",
        path: "/mcp/tools/patient/list",
      },
      {
        name: "create_patient",
        description: "Add new patient",
        method: "POST",
        path: "/mcp/tools/patient/create",
      },
      {
        name: "update_patient",
        description: "Update patient by ID",
        method: "PUT",
        path: "/mcp/tools/patient/update",
      },
      {
        name: "delete_patient",
        description: "Delete patient by ID",
        method: "DELETE",
        path: "/mcp/tools/patient/delete",
      },
    ],
  });
});

// 🔹 List Patients
app.get("/mcp/tools/patient/list", async (req, res) => {
  try {
    const patients = await prisma.patient.findMany();
    res.json({ success: true, data: patients });
  } catch (error) {
    console.error("Error listing patients:", error);
    res.status(500).json({ success: false, message: "Error fetching patients" });
  }
});

// 🔹 Create Patient
app.post("/mcp/tools/patient/create", async (req, res) => {
  try {
    const { firstName, lastName, phone } = req.body;
    if (!firstName || !phone) {
      return res
        .status(400)
        .json({ success: false, message: "firstName and phone are required" });
    }

    const newPatient = await prisma.patient.create({
      data: { firstName, lastName, phone },
    });

    res.json({ success: true, message: "Patient created", data: newPatient });
  } catch (error) {
    console.error("Error creating patient:", error);
    res.status(500).json({ success: false, message: "Error creating patient" });
  }
});

// 🔹 Update Patient
app.put("/mcp/tools/patient/update", async (req, res) => {
  try {
    const { id, firstName, lastName, phone } = req.body;

    if (!id) {
      return res.status(400).json({ success: false, message: "id is required" });
    }

    const updatedPatient = await prisma.patient.update({
      where: { id: Number(id) },
      data: { firstName, lastName, phone },
    });

    res.json({ success: true, message: "Patient updated", data: updatedPatient });
  } catch (error) {
    console.error("Error updating patient:", error);
    res.status(500).json({ success: false, message: "Error updating patient" });
  }
});

// 🔹 Delete Patient
app.delete("/mcp/tools/patient/delete", async (req, res) => {
  try {
    const { id } = req.body;

    if (!id) {
      return res.status(400).json({ success: false, message: "id is required" });
    }

    await prisma.patient.delete({ where: { id: Number(id) } });
    res.json({ success: true, message: "Patient deleted successfully" });
  } catch (error) {
    console.error("Error deleting patient:", error);
    res.status(500).json({ success: false, message: "Error deleting patient" });
  }
});

const PORT = 3001;
app.listen(PORT, () =>
  console.log(`✅ Simple MCP Express server running on http://localhost:${PORT}`)
);
