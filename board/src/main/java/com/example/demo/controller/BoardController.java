package com.example.demo.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.Category;
import com.example.demo.dto.Paging;
import com.example.demo.dto.board.BoardDto;
import com.example.demo.dto.board.ReplyReqDto;
import com.example.demo.dto.board.ReplyResDto;
import com.example.demo.dto.file.FileResDto;
import com.example.demo.service.BoardService;
import com.example.demo.service.FileService;

@Controller
public class BoardController {

	@Autowired
	private BoardService bs;

	@Autowired
	private FileService fileService;

	/* 목록 페이지 이동 */
	@RequestMapping("/list")
	public String boardList(Paging paging, Model model, HttpServletRequest request) {
		List<Category> catList = bs.getCategory("CTG"); // 카테고리 조회

		model.addAttribute("catList", catList);
		model.addAttribute("paging", paging);

		return "list";
	}

	/* 글 목록, 페이징, 검색, 정렬, */
	@GetMapping("/getBoardList")
	@ResponseBody
	public Map<String, Object> getBoardList(@RequestParam(defaultValue = "1") int page, Paging paging) {
		Map<String, Object> getBoard = new HashMap<>();

		int boardTot = bs.getBoardTot(paging); // 게시글 수
		paging.pageInfo(page, boardTot); // 페이징 처리
		List<BoardDto> boardList = bs.getBoardList(paging); // 글 목록

		getBoard.put("paging", paging);
		getBoard.put("boardList", boardList);
		getBoard.put("boardTot", boardTot);

		return getBoard;
	}

	/* 글 상세 정보 페이지 이동 */
	@PostMapping("/detail")
	public String getBoardDetail(int board_no, Paging paging, Model model) {

		BoardDto getBoardDetail = bs.getBoardDetail(board_no); // 게시글 상세 조회
		int result = bs.hitBoard(board_no); // 조회수 증가
		List<FileResDto> files = fileService.getUploadFiles(board_no); // 업로드된 파일 목록

		model.addAttribute("board", getBoardDetail);
		model.addAttribute("files", files);
		model.addAttribute("paging", paging);

		return "detail";
	}

	/* 글 작성 페이지 이동 */
	@PostMapping("/edit")
	public String edit(@RequestParam(defaultValue = "0")int board_no, Paging paging, Model model) {
		List<Category> catList = bs.getCategory("CTG"); // 카테고리 조회
		BoardDto getBoardDetail = bs.getBoardDetail(board_no); // 게시글 상세 조회
		List<FileResDto> files = null;
		if(board_no != 0) {
			files = fileService.getUploadFiles(board_no); // 업로드된 파일 목록
		}

		model.addAttribute("paging", paging);
		model.addAttribute("catList", catList);
		model.addAttribute("board", getBoardDetail);
		model.addAttribute("files", files);

		return "edit";
	}

	/* 글 작성 처리 */
	@PostMapping("/write")
	@ResponseBody
	@Transactional
	public int writeBoard(BoardDto board, @RequestParam("file") List<MultipartFile> files, int[] ord, HttpServletRequest request) {
		// 글 작성 처리
		int result = bs.writeBoard(board);

		int order = 1;
		String src = "";
		String title = "";
		String cont = board.getCont();
		Pattern pattern1 = Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>"); // src 값 가져오기
		Pattern pattern2 = Pattern.compile("<img[^>]*title=[\"']?([^>\"']+)[\"']?[^>]*>"); // title 값 가져오기
		Matcher matcher1 = pattern1.matcher(cont);
		Matcher matcher2 = pattern2.matcher(cont);
		String rlPath = request.getSession().getServletContext().getRealPath("/");

		while (matcher1.find() && matcher2.find()) {
			src = matcher1.group(1);
			title = matcher2.group(1);
			fileService.saveImg(rlPath + src, title, board.getBoard_no(), order++); // 이미지 업로드
		}

		// 파일 업로드
//		fileService.saveFile(files, board.getBoard_no(), ord);

		return result;
	 }

	/* 수정 & 삭제 팝업 */
	@GetMapping("/popup")
	public String popup() {
		return "popup";
	}

	/* 수정, 삭제 시 비밀번호 체크 */
	@PostMapping("/chkPwd")
	@ResponseBody
	public boolean password_chk(int board_no, String password) {
		return bs.password_chk(board_no, password);
	}

	/* 글 수정 */
	@PostMapping("/update")
	@ResponseBody
	@Transactional
	public int updateBoard(BoardDto board, @RequestParam("file") List<MultipartFile> files, int ord[]) {
		// 게시글 업데이트
		int result = bs.updateBoard(board);

		// 파일 업로드
		fileService.saveFile(files, board.getBoard_no(), ord);

		return result;
	}

	/* 글 삭제 */
	@PostMapping("/delete")
	@Transactional
	public String deleteBoard(int board_no) throws IOException {
		// 게시글 삭제
		int result = bs.deleteBoard(board_no);

		List<FileResDto> deleteFileList = fileService.getUploadFiles(board_no); // 게시글 번호에 업로드된 파일 가져오기

		// 파일 삭제
		fileService.deleteLocalFile(deleteFileList); // Local 파일 리스트 삭제

		return "redirect:list";
	}

	/* 답글 조회 + 페이징 */
	@GetMapping("/reply")
	@ResponseBody
	public Map<String, Object> getReplyList(ReplyReqDto replyReqDto,
											@RequestParam(defaultValue = "1") int page) {
		Map<String, Object> getReply = new HashMap<>();

		int replyCount = bs.getReplyCount(replyReqDto); // 해당 게시물 답글 개수
		replyReqDto.pageInfo(page, replyCount); // 페이징 처리
		List<ReplyResDto> replyResDto = bs.getReplyList(replyReqDto); // 해당 게시물 답글 조회

		getReply.put("paging", replyReqDto);
		getReply.put("replyList", replyResDto);
		getReply.put("replyCount", replyCount);

		return getReply;
	}

	/* 답글 작성 */
	@PostMapping("/reply")
	@ResponseBody
	@Transactional
	public int writeReply(ReplyReqDto replyReqDto) {
		int result = bs.writeReply(replyReqDto); // 답글 작성

		return result;
	}

	/* 답글 삭제 */
	@DeleteMapping("/reply")
	@ResponseBody
	@Transactional
	public int deleteReply(int reply_no) {
		int result = bs.deleteReply(reply_no); // 답글 삭제

		return result;
	}

	/* 답글 수정 */
	@PutMapping("/reply")
	@ResponseBody
	@Transactional
	public int updateReply(ReplyReqDto replyReqDto) {
		int result = bs.updateReply(replyReqDto); // 답글 수정

		return result;
	}

	/* 답글 비밀번호 확인 */
	@GetMapping("/replyPwdChk")
	@ResponseBody
	public int replyPwdChk(ReplyReqDto replyReqDto) {
		int result = bs.replyPwdChk(replyReqDto); // 비밀번호 일치 확인

		return result;
	}

	/* 답글 가져오기 */
	@GetMapping("/getReply")
	@ResponseBody
	public ReplyResDto getReply(int reply_no) {
		ReplyResDto replyResDto = bs.getReply(reply_no);

		return replyResDto;
	}

}