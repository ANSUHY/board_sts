<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script type="text/javascript">
			$(document).ready(function() {
				// lnb active
				gnb("1", "1");
			});

			/* 게시글 목록 페이지 이동 */
			function list() {
				$("#detailFrm").attr("action", "/list").submit();
			}

			/* 수정 & 삭제 팝업 */
			function openPopup(actionUrl) {
				window.open("", "popup", "width=450, height=180, scrollbars=yes, resizable=yes");

				$("input[name=actionUrl]").attr("value", actionUrl);
				$("#detailFrm").attr("action", "/popup"); // action = "/popup"
				$("#detailFrm").attr("method", "get"); // method = "get"
				$("#detailFrm").attr("target", "popup"); // target = "popup"
				$("#detailFrm").submit(); // submit
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
						<!-- <tr>
						<th class="fir">첨부파일</th>
						<td colspan="3">
							<span><a href="#">상담내역1.xlsx</a></span>
							<br />
							<span><a href="#">상담내역2.xlsx</a></span>
						</td>
						</tr> -->
					</tbody>
				</table>

				<div class="btn-box r">
					<a href="javascript:void(0)" onclick="openPopup('/update')" class="btn btn-green">수정</a>
					<a href="javascript:void(0)" onclick="openPopup('/delete')" class="btn btn-red">삭제</a>
					<a href="javascript:void(0)" onclick="list()" class="btn btn-default">목록</a>
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
