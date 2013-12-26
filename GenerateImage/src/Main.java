import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Main {

	public static final int WIDTH = 105;
	public static final int HEIGHT = 122;
	
	public final String OUTPUT_TRAIN_FILE_NAME = "output_train";
	public final String OUTPUT_TEST_FILE_NAME = "output_test";
	
	public File file;
	public File matlabFile;
	
	public static void main(String[] params) {
		Main main = new Main();
	}
	
	public Main() {
		
		readData("ml2013final_train.dat", true, OUTPUT_TRAIN_FILE_NAME);
		readData("ml2013final_test1.nolabel.dat", true, OUTPUT_TEST_FILE_NAME);
	}
	
	
	public int readData(String inputFilePath, boolean isSave, String outFilePath) {
		
		file = new File(outFilePath);
		matlabFile = new File(outFilePath + "_matlab");
		
		if (file.exists())
			file.delete();
		if (matlabFile.exists())
			matlabFile.delete();
		
		try {
			file.createNewFile();
			matlabFile.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		int res = 13;
		int total = 0;
		
		int[] num = new int[13];
        for (int i = 0 ; i < num.length ; ++i) {
        	num[i] = 0;
        }
		
	    try {
	    	BufferedReader br = new BufferedReader(new FileReader(inputFilePath));
	        String line = br.readLine();

	        while (line != null) {
	        	
	        	double[][] data = new double[HEIGHT][WIDTH];
	        	StringBuilder sb = new StringBuilder();
	            sb.append(line);
	            sb.append('\n');
	            line = br.readLine();

	            String everything = sb.toString();
	            
	            
	            //(TODO) need handle when there is no data.
	            if(everything.length() < 3) {
	            	res = Integer.parseInt(everything.substring(0, everything.length()-1));
	            	double[] d = new double[1];
	            	d[0] = 0;
	            	saveDataArray(res, d);
	            } else{
	            	String[] arr = everything.split(" ");
	            	res = Integer.parseInt(arr[0]);
	            	
	            	for(int i = 1 ; i < arr.length ; ++i) {
	            		String[] s = arr[i].split(":");
	            		int index = Integer.parseInt(s[0]);
	            		double value = Double.parseDouble(s[1]);
	            		
	            		data[(index-1)/WIDTH][(index-1)%WIDTH] = value;
	            	}
	            	
	            	++num[res];
	            	
	            	if (isSave) {
	            		String filepath;
	            		if(res == 0) {
	            			filepath = "test/"+res+"_"+num[res]+".png";
	            		} else {
	            			filepath = "out/"+res+"_"+num[res]+".png";
	            		}
	            		
//	            		Utils.saveImage(data, filepath);
	            		
	            		//double[][] scaledImg = Utils.scaleData(Features.getMinimumRange(Utils.removeSingularPoint(data)), 40, 40);
	            		Utils.saveImage(Utils.scaleData(Utils.changeToSquare(Features.getMinimumRange(Utils.removeSingularPoint(Features.getSmoothImage(data)))), 40, 40), filepath);
	            		
	            		_(total++ + " : " +res+"_"+num[res]+".png" );
	            		
	            	}
	            	
	            	saveDataArray(res, getFeatures(data));
	            }
	            
	            
//	            if(total >= 20) break;
	        }
	        
	        _("done");
	        br.close();
			
	    } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
	    return res;
	}

	public static void _(String str) {
		System.out.print(str+"\n");
	}
	
	private double[] getFeatures(double[][] data) {
		ArrayList<Double> features = new ArrayList<Double>();
		
		features.add((double)Features.getPointNum(Utils.scaleData(Features.getMinimumRange(Utils.removeSingularPoint(Features.getSmoothImage(data))), 20, 20)));
		features.add((double)Features.getMaxSwitchTimes(data));
		features.add((double)Features.getMaxSwitchTimesHorizon(data));
		features.add((double)Features.getRemoveArea(data));
		
		double[][] scaledImg = Utils.scaleData(Features.getMinimumRange(Utils.removeSingularPoint(Features.getSmoothImage(data))), 40, 40);
		
		for(int i = 0 ; i < 40 ; i++) {
			for (int j = 0 ; j < 40 ; j++) {
				features.add(scaledImg[i][j]);
			}
		}
		
		double[] res = new double[features.size()];
		int index = 0;
		for (double d : features) {
			res[index++] = d;
		}
		return res;
	}
	
	private void saveDataArray(int y, double[] x) throws IOException {
		FileOutputStream fos = new FileOutputStream(file, true);
		DataOutputStream dos = new DataOutputStream(fos);

		FileOutputStream mfos = new FileOutputStream(matlabFile, true);
		DataOutputStream mdos = new DataOutputStream(mfos);
		
		dos.writeChars(Double.toString(y));
		mdos.writeChars(y+"");
		
		// sparse format start from 1
		int index = 1;
		for (double d : x) {
			if (d > 0)
				dos.writeChars(" " + index + ":" + d);
			mdos.writeChars(" " + d);
			
			index++;
		}
		
		dos.writeChars("\n");
		mdos.writeChars("\n");
		dos.close();
		mdos.close();
	}
}
