<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script>
			const write = {
				reqUrl : "/write",
				resUrl : "/list"
				};

			const update = {
				reqUrl : "/update",
				resUrl : "/datail"
			};

			let bNoIsEmpty = "${board.board_no}" == "" || "${board.board_no}" == null; // true -> write, false -> update
			let url = bNoIsEmpty ? write : update;
			console.log(url); // delete later

			/*  */
			$(document).ready(function() {
				// lnb active
				gnb("1", "1");

				// write & update div
				udtDiv();
			});

			/* 작성 수정 구분 */
			function udtDiv() {
				if (!bNoIsEmpty) { // 수정
					// 각 요소 수정
					$("input[name=writer_nm]").remove();
					$(".udt").remove();
					$(".writer_nm").attr("colspan", "3");

					// 수정할 때 등록된 값 불러오기
					$(".writer_nm").text("${board.writer_nm}");
					$("select[name=category_cd]").val("${board.category_cd}").attr("selected", "selected");
					$("input[name=title]").attr("value", "${board.title}");
					$("textarea[name=cont]").text("${board.cont}");
				}
			}

			/* 작성 */
			function saveAction() {
				if(confirm("저장하시겠습니까?")) { // 저장 여부
					/* 줄 바꿈 */
					/* let cont = $("textarea[name=cont]").val();
					cont = cont.replace(/(?:\r\n|\r|\n)/g, '<br />');
					$("textarea[name=cont]").html(cont); */

					$.ajax({
						url: url.reqUrl,
						method: "POST",
						data: $("#editFrm").serialize(), // 입력 폼에 담겨있는 정보
						success : function(data) {
							if (data > 0) {
								alert('저장되었습니다.');
							} else {
								alert("저장 실패");
							}

							location.href = url.resUrl; // update later
						}
					});
				}
			}

			/* 게시글 목록 페이지 이동 */
			function list() {
				$("#editFrm").attr("action", "/list").submit();
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

				<form id="editFrm" method="post">
					<input type="hidden" name="board_no" value="${board.board_no }">
					<table class="write">
						<colgroup>
							<col style="width: 150px" />
							<col />
							<col style="width: 150px" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="fir">
									작성자
									<i class="req">*</i>
								</th>
								<td class="writer_nm">
									<input type="text" class="input block" name="writer_nm" required="required"/>
								</td>
								<th class="fir udt">
									비밀번호
									<i class="req">*</i>
								</th>
								<td class="udt">
									<input type="password" class="input block" name="password" required="required"/>
								</td>
							</tr>
							<tr>
								<th class="fir">
									카테고리
									<i class="req">*</i>
								</th>
								<td colspan="3">
									<select class="select" name="category_cd" style="width: 150px">
										<c:forEach var="cat" items="${catList}">
											<option value="${cat.comm_cd }">${cat.comm_cd_nm }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th class="fir">
									제목
									<i class="req">*</i>
								</th>
								<td colspan="3">
									<input type="text" class="input" name="title" style="width: 100%" required="required"/>
								</td>
							</tr>
							<tr>
								<th class="fir">
									내용
									<i class="req">*</i>
								</th>
								<td colspan="3">
									<textarea name="cont" style="width: 100%; height: 300px" required="required"></textarea>
								</td>
							</tr>
							<!-- <tr>
							<th class="fir">첨부파일 1 <i class="req">*</i></th>
							<td colspan="3">
								<span><a href="#">상담내역1.xlsx</a> <a href="#" class="ic-del">삭제</a></span>
								<br />
								<input type="file" class="input block mt10" />
							</td>
							</tr>
							<tr>
							<th class="fir">첨부파일 2</th>
							<td colspan="3">
								<span><a href="#">상담내역2.xlsx</a> <a href="#" class="ic-del">삭제</a></span>
								<br />
								<input type="file" class="input block mt10" />
							</td>
							</tr>
							<tr>
							<th class="fir">첨부파일 3</th>
							<td colspan="3">
								<input type="file" class="input block mt10" />
							</td>
							</tr> -->
						</tbody>
					</table>
				</form>

				<div class="btn-box r">
					<a href="javascript:void(0);" onclick="saveAction()" class="btn btn-red">저장</a>
					<a href="javascript:void(0);" onclick="list()" class="btn btn-default">취소</a>
				</div>
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
