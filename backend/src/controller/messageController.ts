import { Request, Response } from "express";
import Message from "../models/messageModel";
import mongoose from "mongoose";

export const createMessage = async (req: Request, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { conversationId } = req.params;
    const { content } = req.body;
    const senderId = req.user.id;

    if (!content) {
      return res.status(400).json({
        success: false,
        message: "content is required",
      });
    }

    if (!mongoose.Types.ObjectId.isValid(conversationId as string)) {
      return res.status(400).json({
        success: false,
        message: "Invalid conversation ID",
      });
    }

    const newMessage = new Message({
      conversationId,
      senderId,
      content,
    });

    await newMessage.save();

    return res.status(201).json({
      success: true,
      message: newMessage,
    });
  } catch (error) {
    console.error("Message create error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to send message",
    });
  }
};

export const fetchMessageByConversationId = async (req: Request, res: Response) => {
    try {
        const {conversationId}=req.params;
        if (!req.user) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  if (!mongoose.Types.ObjectId.isValid(conversationId as string)) {
    return res.status(400).json({
      success: false,
      message: "Invalid conversation ID",
    });
  }
        const messages=await Message.find({conversationId}).sort({createdAt:1})
        return res.status(200).json({
            success:true,
            messages, 
        })
    } catch (error) {
        console.error("Message fetch error:", error);
        return res.status(500).json({
            success:false,
            message:"Failed to fetch messages",
        })
    }
}

export const sendMessage=async(conversationId:string,senderId:string, content:string)=>{
    try {
        const newMessage=new Message({
            conversationId,
            senderId,
            content,
        })
        await newMessage.save();
        return newMessage;
    } catch (error) {
        console.error("Message fetch error:", error);
        throw new Error("Failed to send message");
    }
}