import express from "express";
import connectDB from "./models/db";
import authRoute from "./routes/authRoute";
import conversationRoute from "./routes/conversationRoute";
import cors from "cors";
import messageRoute from "./routes/messageRoute";
import { Server } from "socket.io";
import http from "http";
import { sendMessage } from "./controller/messageController";

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: "*",
    }
});

connectDB();

app.use(cors());
app.use(express.json());

app.use('/auth', authRoute);
app.use('/conversation', conversationRoute);
app.use('/message', messageRoute);

io.on("connection", (socket) => {
    // console.log("A user connected", socket.id);

    socket.on("joinConversation", (conversationId) => {
        socket.join(conversationId);
        // console.log("User joined conversation", conversationId);
    });

    socket.on("sendMessage", async (message) => {
        const { conversationId, senderId, content } = message;
        // console.log("Message received", message);
        try {
            const newMessage = await sendMessage(conversationId, senderId, content);
            // console.log("Message sent", newMessage);
            io.to(conversationId).emit("newMessage", newMessage);
        } catch (error) {
            console.error("Message send error:", error);
        }
    });

    socket.on("disconnect", () => {
        // console.log("User disconnected", socket.id);
    });
});

const PORT = 5000;

server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});
