<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script src="js/service/HuskyEZCreator.js"></script>
		<script>
			const write = {
				reqUrl : "/write",
				resUrl : "/list"
				};

			const update = {
				reqUrl : "/update",
				resUrl : "/detail",
			};

			let bNoIsEmpty = "${board.board_no}" == "" || "${board.board_no}" == null; // true -> write, false -> update
			let url = bNoIsEmpty ? write : update;
			console.log(bNoIsEmpty);
			console.log(url); //

			$(function() {
				gnb("1", "1");
				udtDiv(); // 작성 수정 구분
			});

			/* 작성 수정 구분 */
			function udtDiv() {
				if (!bNoIsEmpty) { // 수정
					// 각 요소 수정
					$("#editFrm").append("<input type='hidden' name='board_no' value='${board.board_no}'>");
					$("input[name=writer_nm]").remove();
					$(".udt").remove();
					$(".writer_nm").attr("colspan", "3");
					$(".writer_nm").text("${board.writer_nm}");

					// 수정할 때 등록된 값 불러오기
					$("select[name=category_cd]").val("${board.category_cd}").attr("selected", "selected");
// 					$("textarea[name=cont]").text("${fn:replace(board.cont, '<br />', '\\n')}");
				} else { // 작성
					$(".criteria").remove();
				}
			}


			/* 첨부파일 삭제 */
			function delFile(file_no) {
				console.log(file_no);
				if(confirm("파일을 삭제하시겠습니까?")) {
					$.ajax({
						url: "/deleteFile",
						method: "DELETE",
						async: false,
						data: {file_no : file_no},
						success: function(data) {
							if (data > 0) {
								location.reload(); // 삭제 후 화면 새로고침
							} else {
								alert("삭제 실패");
							}
						}
					});
				} else {
					return false;
				}
			}

			/* 빈 값 체크 */
			function validation() {
				if (bNoIsEmpty) { // 작성 시
					// 작성자
					if($("input[name=writer_nm]").val() == "") {
						alert("작성자를 입력해주세요");
						$("input[name=writer_nm]").focus();
						return false;
					}
					// 비밀번호
					if($("input[name=password]").val() == "") {
						alert("비밀번호를 입력해주세요");
						$("input[name=password]").focus();
						return false;
					}
// 					// 첨부파일 (작성)
// 					if(!$("input[name=file]")[0].files.length > 0) {
// 						alert("파일을 첨부해주세요");
// 						return false;
// 					}
				}
				// 제목
				if($("input[name=title]").val() == "") {
					alert("제목을 입력해주세요");
					$("input[name=title]").focus();
					return false;
				}
				// 내용
// 				if($("textarea[name=cont]").val() == "") {
// 					alert("내용을 입력해주세요");
// 					$("input[name=cont]").focus();
// 					return false;
// 				}

				return true;
			}

			/* 게시글 목록 페이지 이동 */
			function list() {
				$("#editFrm").attr("action", "/list").submit();
			}

			/* 네이터 스마트 에디터 */
			var oEditors = [];
			$(function(){
				nhn.husky.EZCreator.createInIFrame({
					oAppRef: oEditors,
					elPlaceHolder: "cont", //textarea에서 지정한 id와 일치해야 합니다.
					//SmartEditor2Skin.html 파일이 존재하는 경로
					sSkinURI: "/SmartEditor2Skin.html",
					htParams : {
						// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseToolbar : true,
						// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseVerticalResizer : true,
						// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
						bUseModeChanger : true,
						fOnBeforeUnload : function(){

						}
					},
					fOnAppLoad : function(){
						//기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용
						//oEditors.getById["cont"].exec("PASTE_HTML", ["${board.cont}"]);
						oEditors.getById["cont"].exec("PASTE_HTML", ['${board.cont}']);
						console.log("dddddd  : " , ${board.cont})
					},
					fCreator: "createSEditor2"
				});
			});

			/* 작성 */
			function saveAction() {
				if (validation()) { // 유효성 검사
					if(confirm("저장하시겠습니까?")) { // 저장 여부
						oEditors.getById["cont"].exec("UPDATE_CONTENTS_FIELD", []);
						let cont = $("textarea[name=cont]").val();
						cont = cont.replaceAll(/(\n|\r\n)/g, "<br />"); // 줄 바꿈
						$("textarea[name=cont]").val(cont);

						let form = $("#editFrm")[0];
						let formData = new FormData(form);

						$.ajax({
							url: url.reqUrl,
							method: "POST",
							contentType: false,
							processData: false,
							data: formData,
							success : function(data) {
								if (data > 0) {
									alert("저장되었습니다.");
								} else {
									alert("저장 실패");
								}

								$("#editFrm").attr("action", url.resUrl); // action = "/popup"
								$("#editFrm").submit();
							}, error : function() {
								alert("저장 실패");
								location.href="list";
							}
						});
					}
				}
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

				<form id="editFrm" method="post" enctype="multipart/form-data">
					<!-- 검색 조건 -->
					<input type="hidden" class="criteria" name="category"	value="${paging.category}">
					<input type="hidden" class="criteria" name="searchType"	value="${paging.searchType}">
					<input type="hidden" class="criteria" name="keyword"	value="${paging.keyword}">
					<input type="hidden" class="criteria" name="sort" 		value="${paging.sort}">
					<input type="hidden" class="criteria" name="listSize" 	value="${paging.listSize}">
					<input type="hidden" class="criteria" name="page" 		value="${paging.page}">

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
									<input type="text" class="input" name="title" value="${board.title}" style="width: 100%" required="required"/>
								</td>
							</tr>
							<tr>
								<th class="fir">
									내용
									<i class="req">*</i>
								</th>
								<td colspan="3">
									<textarea class="form-class" name="cont" id="cont" style="width: 100%; height: 300px" required="required"></textarea>
								</td>
							</tr>
							<!-- 첨부파일 -->
							<c:forTokens var="i" items="1,2,3" delims=",">
								<tr>
									<th class="fir">
										첨부파일 ${i}
										<c:if test="${i == 1}">
											<i class="req">*</i>
										</c:if>
									</th>
									<td colspan="3">
										<c:if test="${files[i-1] != null}">
											<span>
												<a href="/download/${files[i-1].file_no}">${files[i-1].origin_file_nm }</a>
												<a href="javascript:void(0)" onclick="delFile(${files[i-1].file_no})" class="ic-del">삭제</a>
											</span>
											<br />
										</c:if>
										<input type="hidden" name="ord" value="${i}">
										<input type="file" name="file" class="input block mt10" />
									</td>
								</tr>
							</c:forTokens>
						</tbody>
					</table>
				</form>

				<div class="btn-box r">
					<a href="javascript:void(0);" id="save" onclick="saveAction()" class="btn btn-red">저장</a>
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
