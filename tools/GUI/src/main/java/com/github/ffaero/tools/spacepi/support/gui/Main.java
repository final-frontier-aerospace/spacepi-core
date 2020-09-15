package com.github.ffaero.tools.spacepi.support.gui;

import java.awt.Frame;
import java.awt.Graphics2D;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class Main {
	public static void main(String[] args) {

		Frame f = new Frame("Testing");
		f.setSize(800, 600);
		f.setLocationRelativeTo(null);
		f.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
		f.setLayout(null);
		DraggablePanel p1 = new DraggablePanel(new IDrawable() {
			public void draw(Graphics2D g, int w, int h) {
				g.drawString("testing", 10, 10);
			}
		});
		p1.setBounds(50, 50, 200, 200);
		f.add(p1);

		f.setVisible(true);

	}

}
