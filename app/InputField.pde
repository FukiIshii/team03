class InputField {
  float x, y, w, h;
  String label;
  String value = "";
  boolean isActive = false;

  InputField(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(139, 135, 160);
    textSize(11);
    text(label, x, y - 6);

    if (isActive) {
      stroke(159, 174, 234);
    } else {
      stroke(230, 225, 245);
    }
    fill(250, 249, 253);
    rect(x, y, w, h, 8);
    noStroke();

    fill(60);
    textSize(12);
    text(value, x + 10, y + h/2 + 5);

    // カーソルの点滅（アクティブな時だけ）
    if (isActive && frameCount % 60 < 30) {
      float cursorX = x + 10 + textWidth(value) + 1;
      stroke(60);
      line(cursorX, y + 7, cursorX, y + h - 7);
      noStroke();
    }
  }

  boolean isInside(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }

  void handleClick(float mx, float my) {
    isActive = isInside(mx, my); // 自分の中がクリックされた時だけtrue、他は自動でfalse
  }

  void handleKey(char k) {
    if (!isActive) return;
    if (k == BACKSPACE) {
      if (value.length() > 0) value = value.substring(0, value.length() - 1);
    } else if (k == ENTER || k == RETURN) {
      isActive = false; // Enterで確定してフォーカスを外す
    } else if (k != CODED) {
      value += k;
    }
  }
}
