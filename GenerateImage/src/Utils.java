import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;


public class Utils {

	public static void saveImage(double[][] data, String filepath) throws IOException {
		
		int width = data[0].length;
		int height = data.length;
		
		File outputfile = new File(filepath);
		
		BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
		
		for (int i = 0 ; i < width ; i++) {
			for (int j = 0 ; j < height ; j++) {
				img.setRGB(i, j, getGrayScaleColor(data[j][i]));
			}
		}
		
		ImageIO.write(img, "png", outputfile);
	}

	private static int getGrayScaleColor(double d) {
		int i = (d > 0.3f)? 0xff : 0;
		return 0xff000000 | (i<<16) | (i<<8) | i;
	}
	
	public static double[][] scaleData(double[][] data, int targetWidth, int targetHeight) {
		int height = data.length;
		int width = data[0].length;
		double[][] ret = new double[targetHeight][targetWidth];
		
		for (int i = 0 ; i < targetHeight ; ++i) {
			for (int j = 0 ; j < targetWidth ; ++j) {
				int origJ = (int)((double)j * (double)width / (double)targetWidth);
				int origI = (int)((double)i * (double)height / (double)targetHeight);
				ret[i][j] = data[origI % height][origJ % width];
			}
		}
		
		return ret;
	}
	
	public static double[][] changeToSquare(double[][] data) {
		int width = (data.length > data[0].length)? data.length : data[0].length;
		double[][] ret = new double[width][width];
		for (int i = 0 ; i < width ; ++i) {
			for (int j = 0 ; j < width ; ++j) {
				if (i < data.length && j < data[0].length) {
					ret[i][j] = data[i][j];
				} else {
					ret[i][j] = 0;
				}
			}
		}
		return ret;
	}
	
//	
//	public static double[][] replaceMatrix(double[][] data, double[][] mask, double[][] result) {
//		int width = data[0].length;
//		int heoght = data.length;
//		double[][] ret = new double[heoght][width];
//		
//		
//	}
//	
	
	public static double[][] removeSingularPoint(double[][] data) {
		
		double[][] ret = new double[data.length][data[0].length];
		for (int i = 0 ; i < data.length ; ++i) {
			ret[i][0] = 0;
			ret[i][data[0].length-1] = 0;
		}
		
		for (int j = 0 ; j < data[0].length ; ++j) {
			ret[0][j] = 0;
			ret[data.length-1][j] = 0;
		}
		
		double thre = Features.PIXEL_THRESHOLD;
		for (int i = 1 ; i < data.length-1 ; ++i) {
			for (int j = 1 ; j < data[0].length-1 ; ++j) {
				if (data[i][j] >= thre) {
					// if i'm white
					ret[i][j] = ((data[i-1][j] < thre) && (data[i+1][j] < thre) && (data[i][j+1] < thre) && (data[i][j-1] < thre))? 0 : data[i][j]; 
				} else {
					// if i'm black
					double tmp = data[i-1][j] + data[i+1][j] + data[i][j-1] + data[i][j+1];
					tmp /= 4;
					ret[i][j] = ((data[i-1][j] >= thre) && (data[i+1][j] >= thre) && (data[i][j+1] >= thre) && (data[i][j-1] >= thre))? tmp : data[i][j]; 
				}
			}
		}
		
		return ret;
	}
}
