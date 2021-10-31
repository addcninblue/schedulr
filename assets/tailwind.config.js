module.exports = {
  mode: "jit",
  purge: [
    "./js/**/*.js",
    "../lib/*_web/**/*.*ex"
  ],
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    fontFamily: {
      'mono': ['JetBrainsMono'],
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
