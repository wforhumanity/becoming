# forHumanity.art Website

This repository contains the source code for the [forHumanity.art](https://forhumanity.art) website, the public-facing presence for an artist collective building open-source tools for reflection, healing, and growth.

## 🌐 About forHumanity.art

forHumanity.art is an artist collective creating open-source tools for reflection, healing, growth, and experimentation. We are a calm, curious, human-first tech project. forHumanity is a non-profit, donation-supported collective — all tech decisions favor open platforms, long-term affordability, and ethical sustainability.

## 🛠️ Technology Stack

This website is built with:

- **[Astro](https://astro.build/)**: A modern static site builder with excellent performance and developer experience
- **HTML/CSS**: Clean, semantic markup and styling
- **Minimal JavaScript**: Used only where necessary for enhanced functionality
- **Markdown**: For content management

## 📁 Project Structure

```
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
    Nav.astro           // Navigation component
    Footer.astro        // Footer component
  styles/
    global.css          // Global styles
  assets/
    images/             // Site images
    icons/              // SVG icons

public/
  styles/               // Compiled CSS
  favicon.svg          // Site favicon
```

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/forhumanity-org/website.git
   cd website
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   yarn install
   ```

3. Start the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

4. Open your browser and navigate to `http://localhost:3000`

### Building for Production

To build the site for production:

```bash
npm run build
# or
yarn build
```

The built files will be in the `dist/` directory.

## 🤝 Contributing

We welcome contributions from anyone who shares our values. Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Commit your changes**:
   ```bash
   git commit -m "Add some feature"
   ```
5. **Push to the branch**:
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request**

Please make sure your code follows our style guidelines and passes all tests.

## 📝 Content Guidelines

When contributing content to the website, please follow these guidelines:

- Use clear, concise language
- Be inclusive and respectful
- Focus on our core values: reflection, healing, growth, and experimentation
- Avoid jargon and technical terms where possible
- Use Markdown for formatting

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

For questions or suggestions, please contact us at [hello@forhumanity.art](mailto:hello@forhumanity.art).

---

🧠 Built by Human #1.  
🌍 forHumanity.art • created by humans, for humanity
