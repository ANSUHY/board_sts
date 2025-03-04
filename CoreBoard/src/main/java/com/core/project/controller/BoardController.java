package com.core.project.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.core.project.model.dto.GetBoardDetailReqDTO;
import com.core.project.model.dto.GetBoardListReqDTO;
import com.core.project.model.dto.GetBoardListResDTO;
import com.core.project.model.dto.ViewBoardListResDTO;
import com.core.project.model.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	protected BoardService boardService;

	/**
	 * <PRE>
	 * 1. 개요 : [boardList] 화면
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : boardList
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@GetMapping("/boardList")
	public String boardList() {
		return "board/boardList";
	}

	/**
	 * <PRE>
	 * 1. 개요 : [boardList] 리스트내용
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : getBoardList
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/getBoardList")
	@ResponseBody
	public GetBoardListResDTO getBoardList(GetBoardListReqDTO getBoardListReqDTO ) {

		GetBoardListResDTO boardListData 	= new GetBoardListResDTO();
		Map<String, Object> boardDataMap = boardService.getBoardListData(getBoardListReqDTO);

		boardListData.setBoardList((List<ViewBoardListResDTO>) boardDataMap.get("boardList"));
		boardListData.setTotalCount((int) boardDataMap.get("totalCount"));

		return boardListData;
	}

	/** 게시글 상세 보기 (html 뿌리기)*/
	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : findBoardDetail
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@PostMapping(value="/boardDetail")
	public ModelAndView findBoardDetail(GetBoardDetailReqDTO searchData ) {

		System.out.println("DDDDDDDD : " + searchData);

		ModelAndView mv = new ModelAndView();

		mv.addObject("searchData" , searchData);
		mv.setViewName("/board/boardDetail");

		return mv;
	}

	/** 게시판 상세 보기 */
	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : getBoardDetail
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@PostMapping("/getBoardDetail")
	@ResponseBody
	public ViewBoardListResDTO getBoardDetail(@RequestParam("board_no")int board_no) {

		ViewBoardListResDTO boardDetail = new ViewBoardListResDTO();

		boardDetail = boardService.getBoardDetail(board_no);
		boardService.updateCount(board_no);

		return boardDetail;
	}



	/** 게시판 글쓰기/수정 */
	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : updateBoard
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@GetMapping("/updateBoard")
	public ModelAndView updateBoard() {

		//ModelAndView 객체 생성
		ModelAndView mv = new ModelAndView();

		//카테고리명 담아올 DTO 생성
		ViewBoardListResDTO category = new ViewBoardListResDTO();

		List<ViewBoardListResDTO> categoryList = new ArrayList<>();

		//boardService 호출
		categoryList = boardService.getCategoryName();

		mv.addObject("categoryList", categoryList);
		mv.setViewName("/board/writeBoard");

		return mv;
	}

	/** 팝업창 띄우기 */
	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : passwordPopUp
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@GetMapping("/passwordPopUp")
	public String passwordPopUp() {
		return "board/passwordPopUp";
	}

	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : insertBoard
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@PostMapping("/insertBoard")
	@ResponseBody
	public ViewBoardListResDTO insertBoard(ViewBoardListResDTO boardFormData) throws Exception {

		//boardService 호출
		boolean isSuccess = boardService.insertBoard(boardFormData);

		System.out.println("aaaaaa : " + isSuccess);

		return boardFormData;

	}


	/** 비밀번호 찾기 */
	/**
	 * <PRE>
	 * 1. 개요 :
	 * 2. 처리내용  :
	 * 3. Comment   :
	 * </PRE>
	 * @Method Name : findPassword
	 * @date : 2022. 7. 27.
	 * @author : AN
	 * @history :
	 *   -----------------------------------------------------------------------
	 *   변경일            작성자                  변경내용
	 *   ----------- ------------------- ---------------------------------------
	 *   2022. 7. 27.      AN            최초작성
	 *   -----------------------------------------------------------------------
	 *
	 */
	@PostMapping("/findPassword")
	@ResponseBody
	public int findPassword(@RequestParam String password, String boardNum) {

		int board_no = Integer.parseInt(boardNum);

		System.out.println("password : " + password + " board_no : " + board_no);

		//sql에서 비밀번호 비교 후에 true or false 반환하기
		int result = boardService.findPassword(password, board_no);

		System.out.println("findPassword result : " + result);
		return result;
	}

}
