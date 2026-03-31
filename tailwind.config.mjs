/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        brand: {
          red:     '#C0392B',
          green:   '#2D6A4F',
          teal:    '#1A7A6A',
          coral:   '#E85D3A',
          yellow:  '#F5C842',
          cream:   '#FAFAF8',
          sand:    '#F5F0E8',
          dark:    '#1C1C1C',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Poppins', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
