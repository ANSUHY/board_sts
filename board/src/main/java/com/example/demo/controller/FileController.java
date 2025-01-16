package com.example.demo.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.file.FileResDto;
import com.example.demo.service.FileService;


@Controller
public class FileController {

	@Autowired
	private FileService fileService;

	@Value("${spring.servlet.multipart.location}")
	String filePath;

	@GetMapping("/download/{file_no}")
	public ResponseEntity<Resource> download(@PathVariable("file_no") int file_no, HttpServletRequest request) throws IOException {
		FileResDto file = fileService.getFile(file_no); // 첨부파일 정보 가져오기

		Path path = Paths.get(request.getSession().getServletContext().getRealPath("/") + filePath + file.getSave_file_nm()); // 경로 정의

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Disposition", "attachment; filename=" + new String((file.getOrigin_file_nm()).getBytes("UTF-8"), "ISO-8859-1")); // 다운로드 파일명 <= 원본 파일명 & 한글 깨짐 방지

		Resource resource = new InputStreamResource(Files.newInputStream(path));

		fileService.hitDownloadCnt(file_no); // 다운로드 수 증가

		return new ResponseEntity<>(resource, headers, HttpStatus.OK);
	}

	/* 첨부파일 삭제 */
	@DeleteMapping("deleteFile")
	@ResponseBody
	@Transactional
	public int deleteFile(int file_no) throws IOException {
		FileResDto deleteFile = fileService.getFile(file_no); // 삭제하는 파일 조회

		int result = fileService.deleteFile(file_no); // DB File Delete
		fileService.deleteLocalFile(deleteFile); // Local File Delete

		return result;
	}

	@RequestMapping("/multiplePhotoUpload")
	public void multiplePhotoUpload(@RequestHeader("file-name") String filename, HttpServletRequest request, HttpServletResponse response) {
		try {
			String origin_file_nm = filename; // 파일명 - 일반 원본 파일명
			origin_file_nm = URLDecoder.decode(origin_file_nm, "UTF-8"); // 파일명 디코딩 -> 한글로
			String save_file_nm = UUID.randomUUID().toString() + origin_file_nm.substring(origin_file_nm.lastIndexOf(".")); // 저장 파일명
			String dftFilePath = request.getSession().getServletContext().getRealPath("/") + filePath; // 파일 기본 경로
			File file = new File(dftFilePath); // 디렉토리 생성
			if (!file.exists()) {
				file.mkdirs();
			}
			String rlFileNm = dftFilePath + save_file_nm; // 파일 상세 경로

			// 서버에 파일쓰기 //
			InputStream is = request.getInputStream();
			OutputStream os = new FileOutputStream(rlFileNm);
			int numRead;
			byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
			while ((numRead = is.read(b, 0, b.length)) != -1) {
				os.write(b, 0, numRead);
			}
			if (is != null) {
				is.close();
			}
			os.flush();
			os.close();

			// 정보 출력
			String sFileInfo = ""; // 파일정보
			sFileInfo += "&bNewLine=ture";
			sFileInfo += "&sFileName=" + origin_file_nm; // img 태그의 title 속성을 원본 파일명으로 적용시켜주시 위함
			sFileInfo += "&sFileURL=" + filePath + save_file_nm;

			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter print = response.getWriter();
			print.print(sFileInfo);
			print.flush();
			print.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
