const express = require("express");
const app = express();

const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Bluebird Group - Cloud Engineer Assessment",
    instance: process.env.INSTANCE_ID || "unknown",
    timestamp: new Date().toISOString(),
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.listen(port, () => console.log(`App running on port ${port}`));