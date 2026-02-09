import { Router, Request, Response } from "express";
import { verifyToken } from "../middleware/authMiddleware";

import { fetchConversations, createConversation } from "../controller/conversationController";

const router = Router();

/**
 * GET /api/conversations
 * Get all conversations for logged-in user
 */
router.get("/", verifyToken, fetchConversations);

/**
 * POST /api/conversations
 * Create a new conversation with another user
 */
router.post("/", verifyToken, createConversation);

export default router;

