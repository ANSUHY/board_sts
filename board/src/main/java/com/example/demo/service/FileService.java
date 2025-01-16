package com.example.demo.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.file.FileReqDto;
import com.example.demo.dto.file.FileResDto;
import com.example.demo.repository.FileRepository;

@Service
public class FileService {

	@Autowired
	private FileRepository fr;

	@Value("${spring.servlet.multipart.location}")
	String filePath;

	/* 이미지 업로드 */
	public void saveImg(String save_path, String origin_file_name, int ref_pk, int order) {
		File file = new File(save_path);

		FileReqDto fileReqDto = new FileReqDto();
		fileReqDto.setOrigin_file_nm(origin_file_name);
		fileReqDto.setSave_path(save_path.substring(0, save_path.lastIndexOf("/")));
		fileReqDto.setSave_file_nm(file.getName());
		fileReqDto.setExt(save_path.substring(save_path.lastIndexOf(".") + 1));
		fileReqDto.setSize(FileUtils.sizeOf(file));
		fileReqDto.setOrd(order);
		fileReqDto.setRef_tbl("bt_tb_board");
		fileReqDto.setRef_pk(ref_pk);

		fr.saveFile(fileReqDto);
	}

	/* 파일 업로드 */
	public void saveFile(List<MultipartFile> files, int ref_pk, int[] ord) {
		File fileDir = new File("C:\\upload"); // 저장할 폴더 경로

		if (!fileDir.exists()) fileDir.mkdirs(); // 폴더 없으면 생성

		List<FileResDto> pastFileList = getUploadFiles(ref_pk); // 해당 게시글 파일 리스트 가져오기

		if (!files.isEmpty()) { // 첨부파일이 없다면
			int index = 0;
			for (MultipartFile f : files) {
				if (f.getSize() > 0) { // 파일을 첨부했다면
					if(pastFileList.size() > ord[index] - 1) { // 덮어쓰기 업로드
						FileResDto pastFile = pastFileList.get(index); // 기존 파일 가져오기

						// 기존 파일 삭제
						deleteFile(pastFile.getFile_no()); // 기존 파일 DB 데이터 삭제
						deleteLocalFile(pastFile); // 기존 Local 파일 삭제
					}

					String orginalFileName = f.getOriginalFilename(); // 실제 파일 이름
					String ext = orginalFileName.substring(orginalFileName.lastIndexOf(".") + 1); // 파일 확장자
					String saveName = UUID.randomUUID() + "." + ext; // 서버 상에서 파일 이름 겹치는 것을 방지

					File saveFileUrl = new File(saveName); // 실제 경로와 저장될 파일

					try {
						f.transferTo(saveFileUrl); // Local 저장
					} catch (IOException e) {
						e.printStackTrace();
					}

					FileReqDto file = new FileReqDto();
					file.setOrigin_file_nm(orginalFileName);
					file.setSave_path(fileDir.toString());
					file.setSave_file_nm(saveName.toString());
					file.setExt(ext);
					file.setSize(f.getSize());
					file.setOrd(index + 1);
					file.setRef_tbl("bt_tb_board");
					file.setRef_pk(ref_pk);

					fr.saveFile(file); // DB 저장
				}
				index++;
			}
		}
	}

	/* 해당 게시글의 첨부파일 리스트 가져오기 */
	public List<FileResDto> getUploadFiles(int board_no) {
		return fr.getUploadFiles(board_no);
	}

	/* 첨부파일 가져오기 */
	public FileResDto getFile(int file_no) {
		return fr.getFile(file_no);
	}

	/* 다운로드 수 증가 */
	public int hitDownloadCnt(int file_no) {
		return fr.hitDownloadCnt(file_no);
	}

	/* DB 첨부파일 삭제 (특정 파일 하나) */
	public int deleteFile(int file_no) {
		return fr.deleteFile(file_no);
	}

	/* DB 첨부파일 삭제 (해당 게시글에 업로드된 파일들) */
	public int deleteFileAll(List<FileResDto> files) {
		return fr.deleteFileAll(files);
	}

	/* Local 파일 삭제 (특정 파일 하나) */
	public void deleteLocalFile(FileResDto file) {
		Path savedPath = Paths.get(filePath + "\\" + file.getSave_file_nm());

		try {
			Files.delete(savedPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/* 믈리 파일 삭제 (해당 게시글에 업로드된 파일들) */
	public void deleteLocalFile(List<FileResDto> files) {
		if (!files.isEmpty()) {
			for (FileResDto f : files) {
				Path savedPath = Paths.get(filePath + "\\" + f.getSave_file_nm());

				try {
					Files.delete(savedPath);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

}
