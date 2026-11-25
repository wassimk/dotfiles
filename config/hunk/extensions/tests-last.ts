import type { ExtensionDiffFile, HunkExtensionAPI } from "hunkdiff/extension";

const TEST_DIR = /(^|\/)(spec|specs|test|tests|__tests__|__mocks__|testdata)\//;
const TEST_FILE = /(_spec|_test|\.spec|\.test)\.[^/]+$|(^|\/)test_[^/]+\.(py|lua)$|(^|\/)tests?\.rs$/;

function isTestFile(file: ExtensionDiffFile) {
  return TEST_DIR.test(file.path) || TEST_FILE.test(file.path);
}

export default function (hunk: HunkExtensionAPI) {
  hunk.transformChangeset((changeset) => ({
    ...changeset,
    files: [
      ...changeset.files.filter((file) => !isTestFile(file)),
      ...changeset.files.filter(isTestFile),
    ],
  }));
}
