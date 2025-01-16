package com.core.project.model.service;

import java.util.List;
import java.util.Map;

import com.core.project.model.dto.GetBoardListReqDTO;
import com.core.project.model.dto.ViewBoardListResDTO;

public interface BoardService {

	/** 게시판 목록 조회 + 게시판 목록수 조회 */
	Map<String, Object> getBoardListData(GetBoardListReqDTO getBoardListReqDTO);

	/** 게시글 상세보기 */
	ViewBoardListResDTO getBoardDetail(int board_no);

	/** 조회수 증가 */
	void updateCount(int board_no);

	/** 게시글 등록 (카테고리 이름 불러오기) */
	List<ViewBoardListResDTO> getCategoryName();

	/** 게시글 등록하기 */
	boolean insertBoard(ViewBoardListResDTO boardFormData) throws Exception;

	/** 비밀번호 일치 여부 확인하기 (게시글 수정) */
	int findPassword(String password, int board_no);

	/** offset 계산*/
	int returnOffset(int sizePage, int curPage);

}
