import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export const verifyToken=(req:Request, res:Response, next:NextFunction): void => {
    const token = req.headers.authorization?.split(" ")[1];

    if(!token){
        res.status(403).json({message:"Unauthorized 112"});
        return;
    }
    try {
        const decoded = jwt.verify(token, "secretKey");
        req.user = decoded as {id:string};
        next();
    } catch (error) {
        res.status(401).json({message:"Unauthorized321"});
    }
}
