import { Router } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { fetchMessageByConversationId, createMessage } from "../controller/messageController";

const router=Router();

router.get('/:conversationId', verifyToken, fetchMessageByConversationId);

/**
 * POST /api/messages/:conversationId
 * Send a message to a conversation
 */
router.post('/:conversationId', verifyToken, createMessage);

export default router;