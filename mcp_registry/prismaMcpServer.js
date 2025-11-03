import express from "express";
import cors from "cors";
import fs from "fs";
import path from "path";
import dotenv from "dotenv";

dotenv.config();
const app = express();
app.use(express.json());
app.use(cors());

// ✅ Base MCP Registry folder
const registryPath = path.join(process.cwd(), "mcp_registry");

// ✅ 1. MCP Manifest route (ChatGPT expects this)
app.post("/mcp/manifest", (req, res) => {
  return res.json({
    version: "2025-06-18",
    name: "Hospital MCP Server",
    description: "Serves Prisma models as MCP registry files for ChatGPT Bolt.",
    capabilities: {
      registry: true,
      schema: true,
      autocomplete: true,
    },
    endpoints: {
      registry: "/mcp/registry",
    },
  });
});

// ✅ 2. Registry route to list all schema files
app.get("/mcp/registry", (req, res) => {
  try {
    const files = fs.readdirSync(registryPath);
    const registryFiles = files
      .filter((file) => file.endsWith(".json"))
      .map((file) => {
        const content = fs.readFileSync(path.join(registryPath, file), "utf8");
        return {
          name: file.replace(".json", ""),
          content: JSON.parse(content),
        };
      });
    res.json({ success: true, count: registryFiles.length, registryFiles });
  } catch (err) {
    console.error("Registry load error:", err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ✅ 3. Root route for debugging
app.get("/", (req, res) => {
  res.send("✅ Hospital MCP Registry Server is running");
});

const PORT = process.env.MCP_PORT || 3001;
app.listen(PORT, () => {
  console.log(`✅ MCP Registry Server running at: http://localhost:${PORT}`);
  console.log(`📂 Loaded MCP Files Path: ${registryPath}`);
});
