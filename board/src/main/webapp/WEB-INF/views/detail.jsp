<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script type="text/javascript">

			$(function() {
				gnb("1", "1");
				getReplyList();
			});

			/* 게시글 목록 페이지 이동 */
			function list() {
				$("#detailFrm").attr("action", "/list").submit();
			}

			/* 수정 & 삭제 팝업 */
			function openPopup(actionUrl, reply_no) {
				window.open("", "popup", "width=450, height=180, scrollbars=yes, resizable=yes");

				$("input[name=actionUrl]").attr("value", actionUrl);
				$("input[name=reply_no]").attr("value", reply_no);

				$("#detailFrm").attr("action", "/popup"); // action = "/popup"
				$("#detailFrm").attr("method", "get"); // method = "get"
				$("#detailFrm").attr("target", "popup"); // target = "popup"
				$("#detailFrm").submit(); // submit
			}

			/* 답글 목록 조회 */
			function getReplyList(page) {
				$.ajax({
					url : "/reply",
					method : "GET",
					data : {
						page : page,
						board_no : $("input[name=board_no]").val()
					},
					success : function (data) {
						let replyList = data.replyList;
						let replyCount = data.replyCount;
						let paging = data.paging;

						let replyHTML =  "";
						let pagingHTML = "";

						$(".replyCount > strong").html("총 답글 수: <span style='color: #fb546e;'>" + replyCount + "</span> 개");

						if (replyList.length > 0) {
							$.each(replyList, function(i) {
								replyHTML +=
									"<tr>"
								+	"	<td>" + replyList[i].rn + "</td>"
								+	"	<td class='reply-content' style='text-align: left; padding-left: 1rem;'>" + replyList[i].content + "</td>"
								+	"	<td>" + replyList[i].reply_nm + "</td>"
								+	"	<td>" + replyList[i].indate + "</td>"
								+	"	<td>"
								+	"		<button type='button' class='btn btn-green btn-ssm' onclick=openPopup('/update'," + replyList[i].reply_no + ")>수정</button>"
								+	"		<button type='button' class='btn btn-red btn-ssm' onclick=openPopup('/delete'," + replyList[i].reply_no + ")>삭제</button>"
								+	"	</td>"
								+	"</tr>";
							});

							/* 페이징 처리 */
							const firstPage = 1; // 첫 페이지
							let lastPage = paging.pageCnt; // 마지막 페이지
							let prevPage = paging["startPage"] - paging.listSize; // 이전 페이지
							let nextPage = paging["endPage"] + 1; // 다음 페이지

							// 맨 처음으로
							pagingHTML += "<a class='direction fir' href='javascript:getReplyList(" + firstPage + ")'>처음</a>";

							// 이전
							if (paging["prev"]) {
								pagingHTML += "<a class='direction prev' href='javascript:getReplyList(" + prevPage + ")'>이전</a>";
							}

							// 페이지 번호
							for (let i = paging["startPage"]; i <= paging["endPage"]; i++) {
								if (paging.page !== i) {
									pagingHTML += "<a href='javascript:getReplyList(" + i + ")'>" + i + "</a>";
								} else {
									pagingHTML += "<strong>" + i + "</strong>";
								}
							}

							// 다음
							if (paging["next"]) {
								pagingHTML += "<a class='direction next' href='javascript:getReplyList(" + nextPage + ")'>다음</a>";
							}

							// 맨 마지막으로
							pagingHTML += "<a class='direction last' href='javascript:getReplyList(" + lastPage + ")'>끝</a>";
						} else {
							replyHTML +=
									"<tr>"
								+	"	<td colspan=5>작성된 답글이 없습니다.</td>"
								+	"</tr>"
							pagingHTML = pagingHTML += "<strong>1</strong>";
						}

						$(".reply .reply-cont").html(replyHTML);
						$(".paginate_complex").html(pagingHTML);
					}
				});
			}

			/* 답글 작성 */
			function writeReply() {
				$.ajax({
					url : "/reply",
					method : "POST",
					data : {
						board_no : $("input[name=board_no]").val(),
						content : $("textarea[name=content]").val(),
						reply_nm : $("input[name=reply_nm]").val(),
						reply_password : $("input[name=reply_password]").val()
					},
					success : function (data) {
						if (data > 0) {
							// 작성 후 입력값 초기화
							$("textarea[name=content]").val("");
							$("input[name=reply_nm]").val("");
							$("input[name=reply_password]").val("");
							getReplyList(); // 작성을 하고난 뒤 조회
						}
					}, error : function () {
						alert("답글 작성 실패");
					}
				});
			}

			/* 답글 삭제 */
			function deleteReply(reply_no) {
				$.ajax({
					url : "/reply",
					method : "DELETE",
					data : {
						reply_no : reply_no
					},
					success : function (data) {
						if (data > 0) {
							alert("답글이 삭제되었습니다.");
							getReplyList(); // 삭제를 하고난 뒤 조회
						}
					}, error : function () {
						alert("답글 삭제 실패");
					}
				});
			}

			/* 답글 수정 */
			function updateReply(reply_no) {
				$.ajax({
					url : "/reply",
					method : "PUT",
					data : {
						reply_no : reply_no,
						content : $("textarea[name=content]").val()
					},
					success : function (data) {
						if (data > 0) {
							let wrtBtn = "<input type='button' id='replyWrite' value='작성' class='btn btn-red' style='width:12%; display: block; float: right; height: 3rem;' onclick='writeReply()'>"
							alert("답글이 수정되었습니다.");
							$("input[name=reply_nm]").val("");
							$("textarea[name=content]").val("");
							getReplyList(); // 수정 하고난 뒤 조회
							$("#replyUpdate").remove();
							$("textarea[name=content]").after(wrtBtn);
						}
					}, error : function () {
						alert("답글 수정 실패");
					}
				});
			}

			/* 답글 조회 */
			function getReply(reply_no) {
				$.ajax({
					url: "/getReply",
					method: "GET",
					data : { reply_no : reply_no },
					success : function (data) {
						// 가져온 답글
						let uptBtn = "<input type='button' id='replyUpdate' value='수정' class='btn btn-green' style='width:12%; display: block; float: right; height: 3rem;' onclick='updateReply( " + reply_no + ")'>";
						$("textarea[name=content]").val(data.content);
						$("input[name=reply_nm]").val(data.reply_nm);
						$("input[name=reply_nm]").prop("disabled", true);
						$("input[name=reply_password]").prop("disabled", true);
						$("#replyWrite").remove();
						$("textarea[name=content]").after(uptBtn);
					}, error : function () {
						alert("해당 답글 정보를 가져올 수 없습니다.");
					}
				});
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

			<form id="detailFrm" method="post">
				<input type="hidden" name="board_no" value="${board.board_no}">
				<input type="hidden" name="actionUrl">
				<input type="hidden" name="reply_no">

				<!-- 검색 조건 -->
				<input type="hidden" name="category" value="${paging.category}">
				<input type="hidden" name="searchType" value="${paging.searchType}">
				<input type="hidden" name="keyword" value="${paging.keyword}">
				<input type="hidden" name="sort" value="${paging.sort}">
				<input type="hidden" name="listSize" value="${paging.listSize}">
				<input type="hidden" name="page" value="${paging.page}">

				<table class="write">
					<colgroup>
						<col style="width: 150px" />
						<col />
						<col style="width: 150px" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th class="fir">작성자</th>
							<td>${board.writer_nm}</td>
							<th class="fir">작성일시</th>
							<td>${board.reg_dt}</td>
						</tr>
						<tr>
							<th class="fir">카테고리</th>
							<td colspan="3">${board.comm_cd_nm}</td>
							</tr>
							<tr>
							<th class="fir">제목</th>
							<td colspan="3">${board.title}</td>
						</tr>
						<tr>
							<th class="fir">내용</th>
							<td colspan="3">
								${board.cont}
							</td>
						</tr>
						<tr>
							<th class="fir">첨부파일</th>
							<td colspan="3">
								<c:forEach var="files" items="${files}">
									<span>
										<a href="/download/${files.file_no}">${files.origin_file_nm }</a>
									</span>
									<br />
								</c:forEach>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="btn-box r">
					<a href="javascript:void(0)" onclick="openPopup('/edit')" class="btn btn-green">수정</a>
					<a href="javascript:void(0)" onclick="openPopup('/delete')" class="btn btn-red">삭제</a>
					<a href="javascript:void(0)" onclick="list()" class="btn btn-default">목록</a>
				</div>

				<!-- 답글 작성 -->
				<h4 class="h4-tit">답글</h4>
				<table class="write">
					<tbody>
						<tr>
							<th class="fir">작성자</th>
							<td>
								<input type="text" name="reply_nm" style="width: 100%">
							</td>
							<th class="fir">패스워드</th>
							<td>
								<input type="password" name="reply_password" style="width: 100%">
							</td>
						</tr>
						<tr>
							<th class="fir">답글</th>
							<td colspan="3">
								<textarea name="content" style="resize: none; width: 87%; height: 3rem; float: left"></textarea>
								<input type="button" id="replyWrite" value="작성" class="btn btn-red" style="width:12%; display: block; float: right; height: 3rem;" onclick="writeReply()">
							</td>
						</tr>
					</tbody>
				</table>

				<!-- 총 답글 수 -->
				<div class="replyCount" style="margin-top: 1rem;">
					<strong></strong>
				</div>

				<!-- 답글 조회 -->
				<table class="list gray reply">
					<thead>
						<tr>
							<th style="width: 5%">번호</th>
							<th style="width: 65%">내용</th>
							<th style="width: 10%">작성자</th>
							<th style="width: 10%">작성일</th>
							<th style="width: 10%">수정 / 삭제</th>
						</tr>
					</thead>
					<tbody class="reply-cont">
					</tbody>
				</table>

				<!-- 답글 페이징 -->
				<div class="paginate_complex">
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

	<script>
		gnb("1", "1");
	</script>
	</body>
</html>
