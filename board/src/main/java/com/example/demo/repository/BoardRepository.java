package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.Category;
import com.example.demo.dto.Paging;
import com.example.demo.dto.Search;
import com.example.demo.dto.board.BoardDto;
import com.example.demo.dto.board.ReplyReqDto;
import com.example.demo.dto.board.ReplyResDto;

@Mapper
public interface BoardRepository {

	List<BoardDto> getBoardList(Paging pagination);

	int getBoardTot(Search search);

	List<Category> getCategory(String grp_cd);

	BoardDto getBoardDetail(int board_no);

	int writeBoard(BoardDto board);

	int hitBoard(int board_no);

	int updateBoard(BoardDto board);

	int deleteBoard(int board_no);

	String password_chk(int board_no);

	int writeReply(ReplyReqDto replyReqDto);

	List<ReplyResDto> getReplyList(ReplyReqDto replyReqDto);

	int getReplyCount(ReplyReqDto replyReqDto);

	int deleteReply(int reply_no);

	int replyPwdChk(ReplyReqDto replyReqDto);

	int updateReply(ReplyReqDto replyReqDto);

	ReplyResDto getReply(int reply_no);

}