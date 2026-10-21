/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './features/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        canvas: '#f8f9fa',
        charcoal: '#202124',
        graphite: '#3c4043',
        slate: '#5f6368',
        mist: '#dadce0',
        'cloud-shadow': '#c4c6c7',
        'google-blue': '#1a73e8',
        'google-blue-deep': '#1967d2',
        'classroom-green': '#188038',
        'feature-tint': '#e8f0fe',
        success: '#188038',
        warning: '#fbbc04',
        danger: '#d93025',
      },
      fontFamily: {
        display: ['"Google Sans Display"', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        text: ['"Google Sans Text"', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        sans: ['"Google Sans Text"', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      fontSize: {
        display: ['80px', { lineHeight: '1.09', letterSpacing: '-0.8px', fontWeight: '400' }],
        'heading-lg': ['48px', { lineHeight: '1.15', letterSpacing: '-0.288px', fontWeight: '400' }],
        heading: ['28px', { lineHeight: '1.2', letterSpacing: '-0.168px', fontWeight: '400' }],
        'heading-sm': ['22px', { lineHeight: '1.29', letterSpacing: '-0.132px', fontWeight: '500' }],
        subheading: ['18px', { lineHeight: '1.67', letterSpacing: '0.108px', fontWeight: '400' }],
        body: ['16px', { lineHeight: '1.56', letterSpacing: '0.272px', fontWeight: '400' }],
        'body-sm': ['14px', { lineHeight: '1.5', letterSpacing: '0.238px', fontWeight: '400' }],
        caption: ['12px', { lineHeight: '1.5', letterSpacing: '0.432px', fontWeight: '400' }],
      },
      borderRadius: {
        pill: '200px',
      },
      maxWidth: {
        container: '1200px',
        hero: '800px',
        text: '640px',
      },
    },
  },
  plugins: [],
};
