import java.util.Random;


public class Features {

	public static final double PIXEL_THRESHOLD = 0.12f;
	
	public static final int MAX_SWITCH_TIMES_TOLERATE = 2;
	
	public static int getPointNum(double[][] data) {
		int res = 0;
		for (double[] dd : data) {
			for (double d : dd) {
				if(d > PIXEL_THRESHOLD)
					res++;
			}
		}
		return res;
	}
	
	public static int getMaxSwitchTimes(double[][] data) {
		
		int maxTimes = 0;
		int preTmp = 0;
		// invert i and j, visit every point from top to bottom.
		for (int j = 0 ; j < data.length ; ++j) {
			int tmp = getSwitchTimes(data[j], MAX_SWITCH_TIMES_TOLERATE);
			if (tmp == preTmp)
				maxTimes =  (maxTimes < tmp)? tmp : maxTimes;
			preTmp = tmp;
		}
		return maxTimes;
	}
	
	public static int getMaxSwitchTimesHorizon(double[][] data) {
		
		double[][] temp = new double[data[0].length][data.length];
		for (int i = 0 ; i < temp.length ; ++i) {
			for (int j = 0 ; j < temp[0].length ; ++j) {
				temp[i][j] = data[j][i];
			}
		}
		
		return getMaxSwitchTimes(temp);
	}
	
	private static int getSwitchTimes(double[] data, int tolerate) {

		boolean flag = false;
		int times = 0;
		int count = 0;
		for (double d: data) {
			if ( d > PIXEL_THRESHOLD != flag) {
				count++;
				if (count == tolerate) {
					flag = !flag;
					times++;
					count = 0;
				}
			} else {
				count = 0;
			}
			
		}
		if (flag)
			times++;
		times/=2;
		return times;
	}
	
	public static int getRemoveArea(double[][] data) {
		int width = data[0].length;
		int height = data.length;
		
		int[] tmp = new int[4];
		
		// 0 1
		// 2 3
		
		for (int i = 0 ; i < width ; ++i) {
			for (int j = 0 ; j < height ; ++j) {
				if(i > width/2) {
					if (j > height/2) {
						// right-bottom
						tmp[3]++;
					} else {
						// right-top
						tmp[1]++;
					}
				} else {
					if (j > height/2) {
						// left-bottom
						tmp[2]++;
					} else {
						// left-top
						tmp[0]++;
					}
				}
			}
		}
		
		double min = Math.min(Math.min(tmp[0], tmp[1]), Math.min(tmp[2], tmp[3]));
		
		for(int i = 0 ; i < 4 ; ++i) {
			if (min == tmp[i]) return i;
		}
		return new Random().nextInt() % 4;
		
	}
	
	public static double[][] getMinimumRange(double[][] data) {
		
		//(TODO) bad algorithm, modify it if have to speed up.
		int top = data.length, bot = 0, left = data[0].length, right = 0;
		for (int i = 0 ; i < data.length ; ++i) {
			for (int j = 0 ; j < data[0].length ; ++j) {
				if (data[i][j] > PIXEL_THRESHOLD) {
					top = (top < i)? top : i;
					bot = i;
					left = (left < j)? left : j;
					right = (right > j)? right : j;
				}
			}
		}
		
		if (top > bot || left > right) {
			Main._("error@getMinimumRange");
			return data;
		} else {
			double[][] ret = new double[bot-top+1][right-left+1];
			for (int i = 0 ; i < ret.length ; ++i) {
				for (int j = 0 ; j < ret[0].length; ++j) {
					ret[i][j] = data[i+top][j+left];
				}
			}
			return ret;
		}
	}
	
	public static double[][] getSmoothImage(double[][] data) {
		int height = data.length;
		int width = data[0].length;
		
        double[][] ret = new double[height][width];
        
        final double[][] filter = {
            {0.01258f ,0.02516f, 0.03145f, 0.02516f, 0.01258f},
            {0.02516f, 0.05660f, 0.07547f, 0.05660f, 0.02516f},
            {0.03145f, 0.07547f, 0.09434f, 0.07547f, 0.03145f},
            {0.02516f, 0.05660f, 0.07547f, 0.05660f, 0.02516f},
            {0.01258f, 0.02516f, 0.03145f, 0.02516f, 0.01258f}
        };
        
        for (int i = 2 ; i < height - 2; ++i) {
        	for (int j = 2 ; j < width - 2; ++j) {
				double tmp = 0;
				for (int m = -2; m < 3; ++m) {
					for (int n = -2; n < 3; ++n) {
						tmp += ((float) data[i + m][j + n] * filter[m + 2][n + 2]);
					}
				}
				ret[i][j] = (double) tmp;
        	}
        }
        
        return ret;
	}
}
