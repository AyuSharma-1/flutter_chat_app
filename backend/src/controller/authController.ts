import {Request,Response} from 'express'
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import userModel from '../models/userModel';

const JWT_SECRET_KEY = 'secretKey';

export const register = async (req:Request, res:Response) => {
  try {

    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ success: false, message: "Missing required fields" });
    }

    const existingUser = await userModel.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new userModel({
      username,
      email,
      password: hashedPassword,
    });
    await newUser.save();

    res
      .status(201)
      .json({
        success: true,
        message: "Registration successful",
        user: {
          id: newUser._id,
          email: newUser.email,
          username: newUser.username,
        },
      });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Register API error",
    });
  }
};

export const login = async (req:Request, res:Response) => {
  try {
    const { email, password } = req.body;

    const user = await userModel.findOne({ email });
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "Invalid Email or Password" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid Credentials" });
    }

    const token = jwt.sign({ id: user._id }, JWT_SECRET_KEY, {
      expiresIn: "10h",
    });

    res.setHeader("Authorization", `Bearer ${token}`);

    res.status(200).json({
      success: true,
      message: "Login successful",
      user: {
        token:token,
        id: user._id,
        email: user.email,
        username: user.username
      },
    });
  } catch (error) { 
    res.status(500).json({
      success: false,
      message: "Login API error",
    });
  }
};
