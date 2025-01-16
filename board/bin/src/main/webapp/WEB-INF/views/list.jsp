<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>

		<script type="text/javascript">
			$(document).ready(function() {
				getBoardList(); // 게시물 목록 조회
				gnb("1", "1"); // lnb active
			});

			/* 게시글 조회, 페이징, 정렬, 검색 */
			function getBoardList(page) {
				$.ajax({
					url: "/getBoardList",
					method: "GET",
					data: {
						page: page,
						category: $("#category").val(),
						sort: $("#sort").val(),
						searchType: $("#searchType").val(),
						keyword: $("#keyword").val(),
						listSize: $("#listSize").val()
					},
					success: function (data) {
						let tot = data.boardTot; // 조회된 게시글 수 data
						let list = data.boardList; // 게시글 data
						let pagination = data.pagination; // 페이징 data

						let content = ""; // 게시글 HTML
						let paging = ""; // 페이징 HTML

 						$(".total > strong").text(tot); // 조회된 게시글 수

						if (list.length > 0) {
							/* 게시글 조회 */
							for(let i = 0; i < list.length; i++) {
								content +=  "<tr>"
										+	"	<td>" + list[i].board_no + "</td>"
										+	"	<td>" + list[i].comm_cd_nm + "</td>"
										+	"	<td class='l'>"
										+	"		<a href='javascript:void(0)' onclick='detail(" + list[i].board_no + ")'>" + list[i].title + "</a>"
										+	"	</td>"
										+	"	<td></td>"
										+	"	<td>" + list[i].writer_nm + "</td>"
										+	"	<td>" + list[i].view_cnt + "</td>"
										+	"	<td>" + list[i].reg_dt + "</td>"
										+	"</tr>";
							}

							// new img $("tbody > .l").append("<img src='/images/new.gif' class='new' alt='new' />");

							/* 페이징 처리 */
							const firstPage = 1; // 첫 페이지
							let lastPage = pagination.pageCnt; // 마지막 페이지
							let prevPage = Math.floor(pagination.page / pagination.listSize); // 이전 페이지
							let nextPage = pagination["endPage"] + 1; // 다음 페이지

							// 맨 처음으로
							paging += "<a class='direction fir' href='javascript:getBoardList(" + firstPage + ")'>처음</a>";

							// 이전
							if (pagination["prev"]) {
								paging += "<a class='direction prev' href='javascript:getBoardList(" + prevPage + ")'>이전</a>";
							}

							// 페이지 번호
							for (let i = pagination["startPage"]; i <= pagination["endPage"]; i++) {
								if (pagination.page !== i) {
									paging += "<a href='javascript:getBoardList(" + i + ")'>" + i + "</a>";
								} else {
									paging += "<strong>" + i + "</strong>";
								}
							}

							// 다음
							if (pagination["next"]) {
								paging += "<a class='direction next' href='javascript:getBoardList(" + nextPage + ")'>다음</a>";
							}

							// 맨 마지막으로
							paging += "<a class='direction last' href='javascript:getBoardList(" + lastPage + ")'>끝</a>";
						} else {
							content += 	"<tr>"
									+	"	<td colspan='7'>조건에 맞는 게시물이 없습니다.</td>"
									+	"</tr>";
						}

						/* 내용 표시 */
						$(".list > tbody").html(content);
						$(".paginate_complex > .page").html(paging);
					},
				});
			}

			/* 검색 */ // 새로고침 안되도록
			function enterKey() {
				if(window.event.key == 13) { // 엔터키
					getBoardList(); // 조회
				}
			}

			/* 게시글 상세 페이지 이동 */
			function detail(board_no) {
				$("#listForm").append("<input type='hidden' name='board_no' value='" + board_no + "'>"); // board_no 값을 매개변수에 받아와서 처리
				$("#listForm").attr("action", "/detail").submit(); // action = "detail" -> submit
			}

			/* 게시글 등록 페이지 이동 */
			function edit() {
				$("#listForm").attr("action", "/edit").submit(); // action = "edit" -> submit
			}
		</script>
	</head>

	<body>
	<div id="wrap">
		<jsp:include page="./common/header.jsp"></jsp:include>

		<div id="container">
		<jsp:include page="./common/lnb.jsp"></jsp:include>

		<div id="contents">
			<div class="location"><span class="ic-home">HOME</span><span>커뮤니티</span><em>통합게시판</em></div>

			<div class="tit-area">
				<h3 class="h3-tit">통합게시판</h3>
			</div>

			<form id="listForm" method="post">
				<!-- 검색 조건 -->
				<!-- <input type="hidden" name="category"	value="">
				<input type="hidden" name="searchType"	value="">
				<input type="hidden" name="keyword"		value="">
				<input type="hidden" name="sort"		value="">
				<input type="hidden" name="listSize"	value="">
				<input type="hidden" name="page"		value=""> -->

				<div class="hide-dv mt10" id="hideDv">
				<table class="view">
					<colgroup>
					<col style="width: 150px" />
					<col />
					</colgroup>
					<tbody>
					<tr>
						<th>카테고리</th>
						<td>
						<select class="select" id="category" style="width: 150px">
							<option value="all">전체</option>
							<c:forEach var="cat" items="${catList}">
								<option value="${cat.comm_cd}">${cat.comm_cd_nm}</option>
							</c:forEach>
						</select>
						</td>
					</tr>
					<tr>
						<th>검색어</th>
						<td>
						<select class="select" id="searchType" style="width: 150px">
							<option value="all">전체</option>
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="titleCont">제목+내용</option>
							<option value="writer">작성자명</option>
						</select>
						<input type="text" name="keyword" id="keyword" class="input" onkeyup="enterKey()" style="width: 300px" />
						</td>
					</tr>
					</tbody>
				</table>
				</div>
				<div class="btn-box btm l">
				<a href="javascript:void(0);" onclick="getBoardList()" class="btn btn-red fr">검색</a>
				</div>

				<div class="tbl-hd noBrd mb0">
				<span class="total">검색 결과 : <strong></strong> 건</span>
				<div class="right">
					<!-- 정렬 -->
					<span class="spanTitle">정렬 순서 :</span>
					<select class="select" id="sort" onchange="getBoardList()" style="width: 120px">
					<option value="last">최근 작성일</option>
					<option value="views">조회수</option>
					</select>
				</div>
				</div>

				<table class="list default">
				<colgroup>
					<col style="width: 60px" />
					<col style="width: 80px" />
					<col />
					<col style="width: 80px" />
					<col style="width: 80px" />
					<col style="width: 80px" />
					<col style="width: 120px" />
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
				<tbody>
					<tr>
						<td colspan="7">작성된 게시물이 없습니다.</td>
					</tr>
				</tbody>
				</table>

				<div class="paginate_complex">
				<!-- PAGINATION	 -->
					<div class="page">
					</div>
					<div class="right">
						<select class="select" id="listSize" onchange="getBoardList()" style="width: 120px">
							<option value="10">10개씩보기</option>
							<option value="20">20개씩보기</option>
							<option value="50">50개씩보기</option>
						</select>
					</div>
				</div>

				<div class="pagingul"></div>

				<div class="btn-box l mt30">
					<a href="javascript:void(0);" onclick="edit()" class="btn btn-green fr">등록</a>
				</div>
			</form>
		</div>
		<!-- /contents -->
		</div>
		<!-- /container -->

		<jsp:include page="./common/quick.jsp"></jsp:include>

		<jsp:include page="./common/footer.jsp"></jsp:include>
	</div>
	<!-- /wrap -->

	</body>
</html>
