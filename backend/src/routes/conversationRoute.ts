import { Router, Request, Response } from "express";
import { verifyToken } from "../middleware/authMiddleware";

import { fetchConversations, createConversation } from "../controller/conversationController";

const router = Router();

router.get("/", verifyToken, fetchConversations);

router.post("/", verifyToken, createConversation);

export default router;

