import express from "express";
import {
  createLabOrder,
  getAllLabOrders,
  getLabOrderById,
  updateLabOrder,
  deleteLabOrder,
} from "../controllers/labController.js";

const router = express.Router();

router.post("/", createLabOrder);
router.get("/", getAllLabOrders);
router.get("/:id", getLabOrderById);
router.put("/:id", updateLabOrder);
router.delete("/:id", deleteLabOrder);

export default router;
