package com.example.demo.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Paging extends Search{

	private int listSize = 10; // 한 페이지당 보여질 리스트의 개수
	private int listCnt; // 전체 게시물의 개수
	private int startList; // 게시판 시작번호

	private int rangeSize = 10; // 한 페이지당 보여질 페이지의 개수
	private int page; // 현재 목록의 페이지 번호
	private int range; // 각 페이지 범위의 시작 번호
	private int pageCnt; // 전체 페이지의 범위의 개수
	private int startPage; // 각 페이지 범위 시작 번호
	private int endPage; // 각 페이지 범위 끝 번호

	private boolean prev; // 이전 페이지
	private boolean next; // 다음 페이지


	public void pageInfo(int page, int listCnt) {
		this.page = page; // 현재 페이지
		this.listCnt = listCnt; // 게시물의 총 개수

		this.range = (int) Math.ceil(page / (double) listSize);

		// 전체 페이지수
		this.pageCnt = (int) Math.ceil(listCnt / (double) listSize); // (전체 게시물의 개수 /  한 페이지당 보여질 리스트의 갯수)

		// 시작 페이지
		this.startPage = (range - 1) * rangeSize + 1; // (각 페이지 범위의 시작 번호 - 1) * 한 페이지당 보여질 페이지의 개수 + 1

		// 마지막 페이지 (마지막 페이지의 번호를 구하는 이유는 [다음] 버튼의 활성화 여부를 판단하기 위해)
		this.endPage = range * rangeSize; // 각 페이지 범위의 시작 번호 * 한 페이지당 보여질 페이지의 개수

		// 게시판 시작번호
		this.startList = (page - 1) * listSize; // (현재 목록의 페이지 번호 - 1) * 한 페이지당 보여질 리스트의 개수

		// 이전 버튼 상태
		this.prev = (range == 1) ? false : true;

		// 다음 버튼 상태
		this.next = endPage > pageCnt ? false : true;
		if (this.endPage > this.pageCnt) {
			this.endPage = this.pageCnt;
			this.next = false;
		}

	}

}
