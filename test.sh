#!/bin/bash

echo "=============================================="
echo " PSEUDO-CLASS / PSEUDO-ELEMENT AUTOGRADER"
echo " TOTAL MARKS: 50"
echo "=============================================="

MARKS=0
TOTAL=50

pass_test() {
    echo "PASS - $1 - $2 marks"
    MARKS=$((MARKS + 2))
}

fail_test() {
    echo "FAIL - $1 - 0 marks"
}

# TEST 1 - index.html exists
if [ -f index.html ]; then
    pass_test "index.html found"
else
    fail_test "index.html not found"
fi

# TEST 2 - styles.css exists
if [ -f styles.css ]; then
    pass_test "styles.css found"
else
    fail_test "styles.css not found"
fi

# Use styles.css for CSS tests. If it does not exist, create an empty variable.
CSS=""
if [ -f styles.css ]; then
    CSS=$(cat styles.css)
fi

# TEST 3 - Correct page title
if grep -qi '<title>[[:space:]]*Pseudo-class selectors[[:space:]]*</title>' index.html; then
    pass_test "Correct page title found"
else
    fail_test "Correct page title not found"
fi

# TEST 4 - Main element and two paragraphs
P_COUNT=$(grep -oi '<p[ >]' index.html | wc -l)
if grep -qi '<main' index.html && [ "$P_COUNT" -ge 2 ]; then
    pass_test "main element and at least two paragraphs found"
else
    fail_test "main element/two paragraphs requirement not satisfied"
fi

# TEST 5 - Three required speaker links
if grep -q 'toobin.html' index.html &&
   grep -q 'sorkin.html' index.html &&
   grep -q 'chua.html' index.html; then
    pass_test "Three required speaker links found"
else
    fail_test "Required speaker links not found"
fi

# TEST 6 - All hyperlinks are bold
if echo "$CSS" | grep -Eq 'a[[:space:]]*\{[^}]*font-weight[[:space:]]*:[[:space:]]*bold'; then
    pass_test "Hyperlinks set to bold"
else
    fail_test "font-weight:bold for hyperlinks not found"
fi

# TEST 7 - :link selector with green
if echo "$CSS" | grep -Eq 'a[[:space:]]*:[[:space:]]*link[[:space:]]*\{[^}]*color[[:space:]]*:[[:space:]]*(green|#008000)'; then
    pass_test ":link selector with green color found"
else
    fail_test ":link green rule not found"
fi

# TEST 8 - :hover and :focus with fuchsia
if echo "$CSS" | grep -Eq 'a[[:space:]]*:[[:space:]]*hover' &&
   echo "$CSS" | grep -Eq 'a[[:space:]]*:[[:space:]]*focus' &&
   echo "$CSS" | grep -Eq 'color[[:space:]]*:[[:space:]]*(fuchsia|#ff00ff)'; then
    pass_test ":hover and :focus with fuchsia found"
else
    fail_test ":hover/:focus fuchsia rule not found"
fi

# TEST 9 - First paragraph bold
if echo "$CSS" | grep -Eq 'main[[:space:]]+p[[:space:]]*:[[:space:]]*first-child[[:space:]]*\{[^}]*font-weight[[:space:]]*:[[:space:]]*bold'; then
    pass_test "main p:first-child bold rule found"
else
    fail_test "main p:first-child bold rule not found"
fi

# TEST 10 - First letter 150%
if echo "$CSS" | grep -Eq 'main[[:space:]]+p[[:space:]]*:[[:space:]]*first-child[[:space:]]*::first-letter[[:space:]]*\{[^}]*font-size[[:space:]]*:[[:space:]]*150%'; then
    pass_test "::first-letter 150% rule found"
else
    fail_test "::first-letter 150% rule not found"
fi

echo "----------------------------------------------"
echo "FINAL SCORE: $MARKS / $TOTAL"

if [ "$MARKS" -eq "$TOTAL" ]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "SOME TESTS FAILED"
    exit 1
fi
