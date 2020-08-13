/**
 * 
 */
package cn.scihi.app;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.Hashtable;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.NotFoundException;
import com.google.zxing.Result;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

/**
 * @author yove
 *
 */
@WebServlet(urlPatterns = { "/images/barcode.png" }, asyncSupported = true)
public class BarcodeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final Logger log = Logger.getLogger(BarcodeServlet.class);

	private static final int width = 300, height = 300;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String text = request.getParameter("text");
			response.setContentType("image/png");
			ServletOutputStream out = response.getOutputStream();
			out.write(getQRCode(text, null));
			out.close();
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	public static byte[] getQRCode(String text, String file) throws Exception {
		Map<EncodeHintType, Object> map = new Hashtable<EncodeHintType, Object>();
		map.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
		map.put(EncodeHintType.CHARACTER_SET, "UTF-8");
		map.put(EncodeHintType.MARGIN, 1);
		BitMatrix bm = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, width, height, map);// QR_CODE、EAN_13(6923450657713)
		if (StringUtils.isNotEmpty(file)) {
			Path path = FileSystems.getDefault().getPath(file);
			MatrixToImageWriter.writeToPath(bm, "PNG", path);
		} else {
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			MatrixToImageWriter.writeToStream(bm, "PNG", out);
			return out.toByteArray();
		}
		return null;
	}

	public static String unifiedDecode(BufferedImage image) throws NotFoundException {
		LuminanceSource source = new BufferedImageLuminanceSource(image);
		BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));
		Hashtable<DecodeHintType, String> hints = new Hashtable<DecodeHintType, String>();
		hints.put(DecodeHintType.CHARACTER_SET, "UTF-8");
		Result result = new MultiFormatReader().decode(bitmap, hints);
		return result.getText();
	}
}
