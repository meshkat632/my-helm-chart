CHART_NAME := my-app
CHART_VERSION := 1.0.0

.PHONY: package
package:
	helm package charts/$(CHART_NAME) -u --version $(CHART_VERSION) --destination ./releases
	helm repo index --url https://meshkat632.github.io/my-helm-charts/ .

.PHONY: release
release:
	@./scripts/bump-chart-version.sh --dir charts/my-app
	helm package charts/$(CHART_NAME) --destination ./releases
	helm repo index --url https://meshkat632.github.io/my-helm-charts/ .
	git add charts/$(CHART_NAME)/Chart.yaml
	git add releases
	git add index.yaml
	git commit -m "Helm Release: $(shell cat charts/$(CHART_NAME)/Chart.yaml | grep version)"
	git push origin main;
	# Set VERSION using the = assignment operator
	CHART_VERSION=$(shell yq eval '.version' charts/$(CHART_NAME)/Chart.yaml); \
	git tag -a $$CHART_VERSION -m "Helm Release: $$CHART_VERSION"; \
	gh release create $$CHART_VERSION --notes "bugfix release" --title "Helm Release: $$CHART_VERSION" --target main; \
	git status; \
	git push origin main; \

.PHONY: clean
clean:
	rm -f $(CHART_NAME)-$(CHART_VERSION).tgz
