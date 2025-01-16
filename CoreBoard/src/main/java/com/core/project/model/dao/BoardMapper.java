package com.core.project.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.core.project.model.dto.GetBoardListReqDTO;
import com.core.project.model.dto.ViewBoardListResDTO;

@Mapper
public interface BoardMapper {

	//board리스트 조회
	List<ViewBoardListResDTO> getBoardList(GetBoardListReqDTO getBoardListReqDTO );

	//board리스트 count 조회
	Object getBoardCount(GetBoardListReqDTO getBoardListReqDTO);

	//게시글 상세 조회
	ViewBoardListResDTO getBoardDetail(int board_no);

	//조회수 증가
	void updateCount(int board_no);

	/** 게시글 등록 (카테고리명 불러오기) */
	List<ViewBoardListResDTO> getCategoryName();
	/** 게시글 등록 (폼 데이터 등록) */
//	int insertBoard(GetBoardListResDTO boardFormData);
	int insertBoard(ViewBoardListResDTO boardFormData);

	/** 비밀번호 일치 여부 */
	int findPassword(String password, int board_no);



}
