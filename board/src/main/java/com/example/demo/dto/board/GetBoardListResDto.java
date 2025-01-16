package com.example.demo.dto.board;

import java.util.List;

import com.example.demo.dto.Paging;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GetBoardListResDto {

	private int boardTot;				// 게시글 총 개수
	private List<BoardDto> boardList;	// 게시글 목록
	private Paging pagination;		// 페이징

}
