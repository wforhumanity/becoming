
# 🌐 forHumanity.art – Website MVP Roadmap

Welcome to the foundation of our public-facing presence for **forHumanity.art** — an artist collective building open-source tools for reflection, healing, and growth.

---

## 🏛️ Purpose

This site introduces the mission of forHumanity.art, showcases our current flagship project (**Becoming**), and lays the foundation for ethical, decentralized participation in future collective work.

---

## 🧱 Framework: Astro

**Why Astro?**
- Lightweight, static-first, but flexible for interactivity
- Markdown content-friendly
- Perfect for clean, minimal design
- Easy to deploy (Netlify, Vercel, GitHub Pages)

---

## 📁 Site Structure

```plaintext
src/
  pages/
    index.astro         // Home
    about.astro         // About the collective
    projects.astro      // Project listing
    projects/becoming.astro // Becoming detail page
    philosophy.astro    // Our ethics and beliefs
    contribute.astro    // How to get involved
  layouts/
    MainLayout.astro    // Shared site structure
  components/
    Nav.astro
    Footer.astro

public/
  assets/               // Logo, images, icons
```

---

## 📝 Page Content

### `/` Home
- Minimal welcome message
- Tagline: *"We are an artist collective building open tools for reflection, healing, and growth."*
- Links to Projects, Philosophy, Contribute

---

### `/about`
- Human #1 message
- Open invitation to contribute
- Our values: transparency, curiosity, care

---

### `/projects`
- List **Becoming** (active)
- Show placeholders (coming soon) for:
  - openTherapy
  - Blanket
  - Resume Matcher

---

### `/projects/becoming`
- What it is, how it works
- Links to GitHub repo, status
- Inspired by the PACT framework

---

### `/philosophy`
- Experiments over goals
- AI as a mirror, not a master
- Decentralized futures, innersource

---

### `/contribute`
- How to help (code, design, writing)
- GitHub links
- Coming soon: community channels, donation info

---

## 🚀 Deployment Plan

- Repo: `github.com/forhumanity-org/website`
- Host: Netlify, Vercel, or GitHub Pages
- DNS: Point `forhumanity.art` to deployed site
- All content editable via Markdown

---

## ✳️ Next Steps

1. Scaffold Astro project
2. Create main layout and routing
3. Populate pages with existing content (Home, About, Becoming)
4. Deploy to Netlify/Vercel
5. Connect domain
6. Open contributions

---

🧠 Built by Human #1.  
🌍 forHumanity.art • created by humans, for humanity
