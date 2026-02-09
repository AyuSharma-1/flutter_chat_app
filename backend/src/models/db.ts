import mongoose from "mongoose";

const connectDB = async () => {
  try {
    await mongoose.connect('mongodb+srv://ayushkumarsharma102_db_user:vxdojwvWqwC5f9Bx@cluster0.bljnaqi.mongodb.net/chat');
    console.log(`Connected To Mongodb ${mongoose.connection.host}`);
  } catch (error) {
    console.log(`Mongodb Error ${error}`);
  }
};

export default connectDB;
