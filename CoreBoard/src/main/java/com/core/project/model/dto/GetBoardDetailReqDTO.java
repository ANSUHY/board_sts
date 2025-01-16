package com.core.project.model.dto;

import lombok.Data;

@Data
public class GetBoardDetailReqDTO {

/** boardList의 검색조건 유지를 위한 DTO */
	/* 검색 조건 */
	private String type;
	/* 검색어 */
	private String keyword;
	/* 카테고리 */
	private String category;
	/* 정렬 순서 */
	private String orderData;
	/* 현재 페이지 */
	private int curPage;
	/* 1페이지당 게시글 수 */
	private int sizePage;

/** 조회를 위한 board_no */
	/* DETAIL BOARD_NO */
	private int board_no;



}
