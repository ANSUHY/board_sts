<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ko">

	<head>
		<!-- head -->
		<%@include file="../layout/head.jsp" %>
		<!--// head -->

		<script>
			$(document).ready(function(){

				/* 초기 작업 */
				fnBoardListInit()

				/* 처음 검색 */
				fnSearchBoardList();

			});

			/*
			 * 함수명 : fnBoardListInit
			 * 설   명 : 초기 작업
			 */
			function fnBoardListInit() {

				//left 색 칠해주기
				gnb('1','1');

				//[검색 버튼] 클릭처리
				$("#searchBtn").on("click", function (){
					fnSearchBoardList(1);
				});

				//[검색어] 엔터 처리
				$(document).on("keydown", "input[name='keyword']", function(key) {
					if(key.keyCode==13)
						fnSearchBoardList(1);
				});

				//[정렬 순서] 변경 되었을때
				$(document).on("change", "select[name='orderData']", function(){
					fnSearchBoardList(1);
				});

				//[{}개씩 보기] 변경 되었을때
				$(document).on("change", "select[id='sPage']", function(){
					fnSearchBoardList(1);
				});

			}

			/*
			 * 함수명 : fnSearchBoardListBoardList
			 * 설   명 : boardList검색
			 */
			function fnSearchBoardList(num){

				if(num === undefined){
					num = 1;
				}

				$("#listArea").html("");

				let sPage = $("#sPage").val();//페이지 사이즈
				let curPage = num;//현재 페이지
				let totalpages = 0;//총 페이지

				$("input[name='sizePage']").val(sPage);	//페이지 사이즈 셋팅
				$("input[name='curPage']").val(curPage);	//현재 페이지 셋팅

				$.ajax({
					type		: 'GET'
					, url		: "/board/getBoardList"
					, dataType 	: "json"
					, data 		: $("form[name=search_form]").serialize()
					, contentType : "application/json; charset=utf-8"
					, success 	: function(result) {

						let list = result.boardList;
						let totalCount = result.totalCount;

						// 1. 검색결과 숫자넣기
						$("#total_cnt").text(totalCount);

						// 2. 리스트 데이터 뿌리기
						if(list.length > 0 ) {
							let listHtml = "";

							$.each(list ,function(index,data) {

								listHtml += "<tr>";
								listHtml += "		<td>" + data.row_num + "</td>";
								listHtml += "		<td>" + data.comm_cd_nm + "</td>";
								listHtml += "		<td class='l' name='title'><a onclick='fnGoDetail(" + data.board_no + ")'>" + data.title;
								if(data.new_icon === 1){
									listHtml += "		<img src='/resources/images/new.gif' class='new' />";
								}
								listHtml += "  		</a></td>";
								listHtml += "		<td>";
								if(data.file_count >= 1){
									listHtml += "		<a href='javascript:void(0)' class='ic-file'></a>";
								}
								listHtml += "		</td>";
								listHtml += "		<td>" + data.writer_nm +"</td>";
								listHtml += "		<td>" + data.view_cnt + "</td>";
								listHtml += "		<td>" + data.reg_dt + "</td>";
								listHtml += "</tr>";

							});

							$("#listArea").html(listHtml);

						} else {
							$("#listArea").html("<tr><td colspan='7'> 검색 결과 없음 </td></tr>");
						}

						// 3. 페이징 처리
						if (totalCount != 0) {
							totalPages = Math.ceil(totalCount / sPage);
							let htmlStr = fnReturnPageHtml(curPage, totalPages, "fnSearchBoardList");
							$("#pageArea").html(htmlStr);
						} else {
							$("#pageArea").html("");
						}

					},
					error : function(xhr, status) {
						console.log(xhr);
						console.log(status);
					}
				});
			}

			/*
			 * 함수명 : fnReturnPageHtml(현재페이지, 전체페이지, 호출할 함수 이름)
			 * 설   명 : 페이지 html 만들어서 리턴
			 */
			function fnReturnPageHtml(curPage, totalPages, funName) {

				let pageUrl = "";

				//1. 한 블럭에 페이지가 10개씩
				let pageLimit = 10;
				let startPage = parseInt((curPage - 1) / pageLimit) * pageLimit +1;
				let endPage = startPage + pageLimit -1;

				if (totalPages < endPage) {
					endPage = totalPages;
				}

				let nextPage = endPage + 1;

				//2. 맨 첫 페이지
				if (curPage > 1 && pageLimit < curPage) {
					pageUrl += "<a class='direction fir' href='javascript:" + funName + "(1);'>처음</a>";
				}
				//3. 이전 페이지
				if(curPage > pageLimit) {
					pageUrl += " <a class='direction prev' href='javascript:" + funName + "(" + (startPage == 1 ? 1 : startPage - 1) + ");'>이전</a>";
				}
				//4. pageLimit 맞게 페이지 수 보여줌
				for (var i = startPage; i <= endPage; i++) {
					//현재 페이지만 진하게 보이기
					if (i == curPage) {
						pageUrl += " <a href='javascript:void(0)'><strong>" + i + "</strong></a>"
					} else {
						pageUrl += " <a href='javascript:" + funName + "(" + i + ");'>" + i + " </a>";
					}
				}
				//5. 다음 페이지
				if (nextPage <= totalPages) {
					pageUrl += "<a class='direction next' href='javascript:" + funName + "(" + (nextPage < totalPages ? nextPage : totalPages) + ");'>다음</a>";
				}
				//6. 맨 마지막 페이지
				if (curPage < totalPages && nextPage < totalPages) {
					pageUrl += "<a class='direction last' href='javascript:" + funName + "(" + totalPages + ");'>끝</a>";
				}

				return pageUrl;
			}

			/*
			 * 함수명 : fnGoDetail(board_no)
			 * 설   명 : 상세페이지로 가기
			 */
			function fnGoDetail(no) {

				//1. 기존 동적 폼 삭제
				$("#frmPost").remove();

				//2. 동적폼생성
				let form = $('<form id="frmPost" name="frmPost"></form>');
				form.attr('action','/board/boardDetail');
				form.attr('method','post');
				form.appendTo('body');

				//3. form 에 들어갈 데이터 셋팅
				let type		= $("<input type='hidden' name='type' value='" 	+ $("#type").val() + "' />");
				let keyword		= $("<input type='hidden' name='keyword' value='" 	+ $("#keyword").val() + "' />");
				let category	= $("<input type='hidden' name='category' value='" 	+ $("#category").val() + "' />");
				let orderData	= $("<input type='hidden' name='orderData' value='" + $("#orderData").val() + "' />");
				let curPage		= $("<input type='hidden' name='curPage' value='" 	+ $("#curPage").val() + "' />");
				let sizePage	= $("<input type='hidden' name='sizePage' value='"	+ $("#sizePage").val() + "' />");
				let board_no	= $("<input type='hidden' name='board_no' value='"	+ no + "' />");
				form.append(type);
				form.append(keyword);
				form.append(category);
				form.append(orderData);
				form.append(curPage);
				form.append(sizePage);
				form.append(board_no);

				//4. form 에 데이터 넣기
				form.submit();
			}
		</script>

	</head>

	<body>

		<div id="wrap">

			<!-- header -->
			<%@include file="../layout/header.jsp" %>
			<!--// header -->

			<div id="container">

				<!-- left -->
				<%@include file="../layout/left.jsp" %>
				<!--// left -->

				<div id="contents">
					<div class="location">
						<span class="ic-home">HOME</span><span>커뮤니티</span><em>통합게시판</em>
					</div>
					<div class="tit-area">
						<h3 class="h3-tit">통합게시판</h3>
					</div>

					<!--  검색 -->
					<form name="search_form" id="search_form" method="post" onsubmit="return false;">
						<input type="hidden" name="curPage"		id="curPage"	value=""/> <!-- form으로 넘기기위해 값을 넣을 input _ 현재페이지 -->
						<input type="hidden" name="sizePage"	id="sizePage"	value=""/> <!-- form으로 넘기기위해 값을 넣을 input _ 페이지 사이즈(한페이지에 몇개 들어갈건지)-->
						<input type="hidden" name="board_no" 	id="board_no"	value=""/> <!-- 여기에다가 board_no 담아서 보내보기 -->

						<div class="hide-dv mt10" id="hideDv">
							<table class="view" id="boardTable">
								<colgroup>
									<col style="width:150px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>카테고리</th>
										<td>
											<select class="select" name="category" id="category" style="width:150px;">
												<option value="">전체</option>
												<option value="CTG001">공지</option>
												<option value="CTG002">중요</option>
												<option value="CTG003">일반</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>검색어</th>
										<td>
											<select class="select" name="type" id="type" style="width:150px;">
												<option value="">전체</option>
												<option value="title">제목</option>
												<option value="cont">내용</option>
												<option value="titleAndCont">제목+내용</option>
												<option value="writer_nm">작성자명</option>
											</select>
											<input type="text" class="input" name="keyword" id="keyword" style="width:300px;">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn-box btm l">
							<a class="btn btn-red fr" id="searchBtn">검색</a>
						</div>
						<div class="tbl-hd noBrd mb0">
							<span class="total">검색 결과 : <strong id="total_cnt"></strong> 건</span>
							<div class="right">
								<span class="spanTitle">정렬 순서 :</span>
								<select class="select" name="orderData" id="orderData" style="width:120px;">
									<option value="reg">최근 작성일</option>
									<option value="cnt">조회수</option>
								</select>
							</div>
						</div>
					</form>

					<table class="list default">
					<colgroup>
						<col style="width:60px;">
						<col style="width:80px;">
						<col>
						<col style="width:80px;">
						<col style="width:80px;">
						<col style="width:80px;">
						<col style="width:120px;">
					</colgroup>
					<thead>
					<tr>
						<th>No</th>
						<th>카테고리</th>
						<th>제목</th>
						<th>첨부파일</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>작성일</th>
					</tr>
					</thead>
						<tbody id="listArea">
							<!-- 리스트 들어갈 곳-->
						</tbody>
					</table>

					<div class="paginate_complex">
						<div id="pageArea">
							<!-- 페이지 들어갈 부분 ( fnReturnPageHtml )-->
						</div>
						<div class="right"> <!-- change이벤트 걸기 -->
							<select class="select" id="sPage" style="width:120px;">
								<option value="10">10개씩보기</option>
								<option value="30">30개씩보기</option>
							</select>
						</div>
					</div>

					<div class="btn-box l mt30" style="clear:both;">
						<a href="/board/updateBoard" class="btn btn-green fr">등록</a>
					</div>

				</div><!-- /contents -->

			</div><!-- /container -->

			<!-- right -->
			<%@include file="../layout/right.jsp" %>
			<!--// right -->

			<!-- footer -->
			<%@include file="../layout/footer.jsp" %>
			<!--// footer -->

		</div><!-- /wrap -->

	</body>
</html>