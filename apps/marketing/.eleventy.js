module.exports = function (eleventyConfig) {
  // Copy static assets
  eleventyConfig.addPassthroughCopy('src/assets');

  // Copy Azure Static Web Apps configuration
  eleventyConfig.addPassthroughCopy('src/staticwebapp.config.json');

  return {
    dir: {
      input: 'src',
      output: 'dist',
      includes: '_includes',
      data: '_data',
    },
    markdownTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',
  };
};
