import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import authRoutes from "./routes/authRoutes.js";
import  appointments  from "./routes/appointmentRoutes.js"

import radiologyRoutes from "./routes/radiologyRoutes.js";
import labRoutes from "./routes/labRoutes.js";
import medicineRoutes from "./routes/medicineRoutes.js";
import patientRoutes from "./routes/patientRoutes.js";
import invoiceRoutes from "./routes/invoiceRoutes.js";
import prescriptionRoutes from "./routes/prescriptionRoutes.js";

dotenv.config();

const app = express();

app.use(cors());
app.use(bodyParser.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/patients", patientRoutes);
app.use("/api/invoices", invoiceRoutes);
app.use("/api/appointments", appointments);
app.use("/api/radiology", radiologyRoutes);
app.use("/api/lab", labRoutes);
app.use("/api/medicines", medicineRoutes);


app.use("/api/prescriptions", prescriptionRoutes);

app.get("/", (req, res) => {
  res.send("Hospital Management Backend Running 🚀");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
