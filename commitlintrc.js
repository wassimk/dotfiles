const Configuration = {
  extends: ["@commitlint/config-conventional"],
  formatter: "commitlint-format-json",
  rules: {
    "header-max-length": [2, "always", 72],
    "body-max-line-length": [2, "always", 72],
  },
};

module.exports = Configuration;
