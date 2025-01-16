package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.Category;
import com.example.demo.dto.Paging;
import com.example.demo.dto.Search;
import com.example.demo.dto.board.BoardDto;
import com.example.demo.dto.board.ReplyReqDto;
import com.example.demo.dto.board.ReplyResDto;
import com.example.demo.repository.BoardRepository;

@Service
public class BoardService {

	@Autowired
	private BoardRepository br;

	/* 목록 조회 */
	public List<BoardDto> getBoardList(Paging pagination) {
		return br.getBoardList(pagination);
	}

	/* 게시글 갯수 조회 */
	public int getBoardTot(Search search) {
		return br.getBoardTot(search);
	}

	/* 글 카테고리 */
	public List<Category> getCategory(String grp_cd) {
		return br.getCategory(grp_cd);
	}

	/* 글 상세 정보 */
	public BoardDto getBoardDetail(int board_no) {
		return br.getBoardDetail(board_no);
	}

	/* 조회수 증가 */
	public int hitBoard(int board_no) {
		return br.hitBoard(board_no);
	}

	/* 글 작성 처리 */
	public int writeBoard(BoardDto board) {
		return br.writeBoard(board);
	}

	/* 글 수정 처리 */
	public int updateBoard(BoardDto board) {
		return br.updateBoard(board);
	}

	/* 글 삭제 처리 */
	public int deleteBoard(int board_no) {
		return br.deleteBoard(board_no);
	}

	/* 수정, 삭제 시 비밀번호 체크 */
	public boolean password_chk(int board_no, String password) {
		boolean isEqualsPwd = false;

		String selectPassword =  br.password_chk(board_no); // 해당 게시글 비밀번호 조회

		if (password.equals(selectPassword)) { // 입력한 비밀번호와 같다면
			isEqualsPwd = true;
		}

		return isEqualsPwd;
	}

	/* 답글 목록 조회 */
	public List<ReplyResDto> getReplyList(ReplyReqDto replyReqDto) {
		return br.getReplyList(replyReqDto);
	}

	/* 답글 작성 */
	public int writeReply(ReplyReqDto replyReqDto) {
		return br.writeReply(replyReqDto);
	}

	/* 답글 삭제 */
	public int deleteReply(int reply_no) {
		return br.deleteReply(reply_no);
	}

	/* 답글 수정 */
	public int updateReply(ReplyReqDto replyReqDto) {
		return br.updateReply(replyReqDto);
	}

	/* 답글 개수 조회 */
	public int getReplyCount(ReplyReqDto replyReqDto) {
		return br.getReplyCount(replyReqDto);
	}

	/* 답글 비밀번호 확인 */
	public int replyPwdChk(ReplyReqDto replyReqDto) {
		return br.replyPwdChk(replyReqDto);
	}

	/* 답글 가져오기 */
	public ReplyResDto getReply(int reply_no) {
		return br.getReply(reply_no);
	}

}
