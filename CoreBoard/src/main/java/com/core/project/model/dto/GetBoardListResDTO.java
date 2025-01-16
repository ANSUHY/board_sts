package com.core.project.model.dto;

import java.util.List;

import lombok.Data;

@Data
public class GetBoardListResDTO {

	private List<ViewBoardListResDTO> boardList;
	private int totalCount;

}
