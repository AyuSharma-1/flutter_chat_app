import Conversation from "../models/conversationModel";
import { Request, Response } from "express";

export const createConversation = async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { participantId } = req.body;
    const userId = req.user.id;

    if (!participantId) {
      return res.status(400).json({
        success: false,
        message: "participantId is required",
      });
    }

    // Check if conversation already exists between these two users
    const existingConversation = await Conversation.findOne({
      participants: { $all: [userId, participantId] },
    });

    if (existingConversation) {
      return res.status(200).json({
        success: true,
        message: "Conversation already exists",
        conversation: existingConversation,
      });
    }

    // Create new conversation
    const newConversation = new Conversation({
      participants: [userId, participantId],
    });

    await newConversation.save();

    return res.status(201).json({
      success: true,
      message: "Conversation created",
      conversation: newConversation,
    });
  } catch (error) {
    console.error("Conversation create error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to create conversation",
    });
  }
};

export const fetchConversations = async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const userID = req.user.id;

    const conversations = await Conversation.find({
      participants: userID,
    })
      .populate({
        path: "participants",
        select: "username email",
        match: { _id: { $ne: userID } },
      })
      .populate({
        path: "lastMessage",
        select: "content createdAt senderId",
      })
      .sort({ updatedAt: -1 });

    return res.status(200).json({
      success: true,
      conversations,
    });
  } catch (error) {
    console.error("Conversation fetch error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch conversations 345",
    });
  }
}