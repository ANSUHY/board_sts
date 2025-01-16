package com.core.project.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.core.project.model.dao.BoardMapper;
import com.core.project.model.dto.GetBoardListReqDTO;
import com.core.project.model.dto.ViewBoardListResDTO;

@Service("BoardService")
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper boardMapper;

	/**
	 * 게시판 목록 조회 + 게시판 목록수 조회
	 */
	@Override
	public Map<String, Object> getBoardListData(GetBoardListReqDTO getBoardListReqDTO) {

		Map<String, Object> boardListData = new HashMap<>();

		//1. offset 계산
		int offset = this.returnOffset(getBoardListReqDTO.getSizePage(), getBoardListReqDTO.getCurPage());
		getBoardListReqDTO.setOffsetData(offset);

		//2. List Data 가져오기
		boardListData.put("boardList", boardMapper.getBoardList(getBoardListReqDTO));

		//3. List Count Data 가져오기
		boardListData.put("totalCount", boardMapper.getBoardCount(getBoardListReqDTO));

		return boardListData;
	}

	/** 게시글 상세 보기 */
	@Override
	public ViewBoardListResDTO getBoardDetail(int board_no) {

		ViewBoardListResDTO boardDetail = new ViewBoardListResDTO();
		boardDetail = boardMapper.getBoardDetail(board_no);

		return boardDetail;
	}

	/** 조회수 증가 */
	@Override
	public void updateCount(int board_no) {
		boardMapper.updateCount(board_no);
	}

	/** 게시글 등록 (카테고리명 불러오기) */
	@Override
	public List<ViewBoardListResDTO> getCategoryName() {
		List<ViewBoardListResDTO> categoryList = new ArrayList<>();
		categoryList = boardMapper.getCategoryName();

		return categoryList;

	}

	/** 게시글 등록 (폼 데이터 등록)
	 * @throws Exception */
	@Override
	public boolean insertBoard(ViewBoardListResDTO boardFormData) throws Exception {

		int result = boardMapper.insertBoard(boardFormData);

		boolean isSuccess = false;

		if(result > 0) {
			isSuccess = true;
		} else {
			throw new Exception("게시글 등록 실패 ");
		}

		return isSuccess;
	}

	/** 비밀번호 일치 여부 확인하기 */
	@Override
	public int findPassword(String password, int board_no) {

		int result = boardMapper.findPassword(password, board_no);

		return result;
	}

	@Override
	public int returnOffset(int sizePage, int curPage) {
		int offset;
		offset = sizePage * (curPage-1);

		return offset;
	}



}
