import express from "express";
import {
  createRadiologyOrder,
  getAllRadiologyOrders,
  getRadiologyOrderById,
  updateRadiologyOrder,
  deleteRadiologyOrder,
} from "../controllers/radiologyController.js";

const router = express.Router();

router.post("/", createRadiologyOrder);
router.get("/", getAllRadiologyOrders);
router.get("/:id", getRadiologyOrderById);
router.put("/:id", updateRadiologyOrder);
router.delete("/:id", deleteRadiologyOrder);

export default router;
