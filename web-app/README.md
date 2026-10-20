# Qrie AI Web Application

Next.js 14+ application providing the **Teacher Portal** and the **School Admin Portal** for Qrie AI.

---

## Directory Structure

```text
web-app/
├── app/
│   ├── (auth)/         # Authentication screens (Login, Session recovery)
│   ├── (teacher)/      # Teacher Portal (Dashboard, Classes, Mastery Heatmaps)
│   ├── (admin)/        # School Admin Portal (Faculty, Students, Compliance)
│   ├── layout.tsx      # Root HTML layout and global metadata
│   └── page.tsx        # Gateway portal selection page
├── components/         # Shared UI components
├── features/           # Domain-specific components
└── public/             # Static brand assets and icons
```

---

## Development

```bash
# Install dependencies
npm install

# Start Next.js development server
npm run dev

# Build for production
npm run build
```
