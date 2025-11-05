import express from "express";
import {
  createPrescription,
  getAllPrescriptions,
  getPrescriptionById,
  deletePrescription,
} from "../controllers/prescriptionController.js";

const router = express.Router();

router.post("/", createPrescription);
router.get("/", getAllPrescriptions);
router.get("/:id", getPrescriptionById);
router.delete("/:id", deletePrescription);

export default router;
