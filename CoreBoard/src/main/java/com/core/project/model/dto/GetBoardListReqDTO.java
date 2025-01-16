package com.core.project.model.dto;

import lombok.Data;

@Data
public class GetBoardListReqDTO {

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

	/* sql에서 쓰일 offset */
	private int offsetData;

}
