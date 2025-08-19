int getBreakTime(int focusMinutes) {
  if (focusMinutes < 5) {
    return 0; // no break, too short
  } else if (focusMinutes < 15) {
    return 2;
  } else if (focusMinutes < 30) {
    return 5;
  } else if (focusMinutes < 45) {
    return 8;
  } else if (focusMinutes < 60) {
    return 12;
  } else {
    return 15; // max cap
  }
}
