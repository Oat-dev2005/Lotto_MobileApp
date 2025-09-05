import express from "express";
import { router as login } from "./controller/login";
import { router as register } from "./controller/register";
import bodyParser from "body-parser";
import cors from "cors";

export const app = express();

app.use(bodyParser.json());
app.use(cors());
app.use("/login", login);
// app.use("/customer", customer);
app.use("/register", register);
